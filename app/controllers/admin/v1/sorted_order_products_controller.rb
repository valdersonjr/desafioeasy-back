module Admin::V1
    class SortedOrderProductsController < ApiController
      before_action :authenticate_user!
      before_action :set_order, only: [:index]

      def index
        order_products = @order.order_products.includes(:product)
        sorted_products = sort_order_products(order_products)
        layered_products = build_layers(sorted_products)
        render json: layered_products, status: :ok
      end

      private

      def set_order
        @order = Order.find(params[:order_id])
      rescue ActiveRecord::RecordNotFound
        render_error(message: "Lista não encontrada", status: :not_found)
      end
#Transformação de cada order product em um hash para manipular mais facilmente os dados do pedido
      def sort_order_products(order_products)
        order_products.map do |order_product|
          {
            id: order_product.id,
            quantity: order_product.quantity,
            box: order_product.box,
            order_id: order_product.order_id,
            product_id: order_product.product_id,
            ballast: order_product.product.ballast,
            name: order_product.product.name
          }
#Após a criação dos hashes a coleção é ordenada por quantity em ordem decrescente          
        end.sort_by { |product| -product[:quantity] }
      end
#Método para montar as camadas
      def build_layers(sorted_products)
#Inicialização de duas listas vazias para armazenar produtos em caixas completas e os que terão sobras        
        full_boxes = []
        leftovers = []
 #Iteração sobre cada produto ordenado   
        sorted_products.each do |product|
#Divmod usado para dividir a quantidade sobre o ballast, resultando o número de caixas completas (full_box_count) e a quantidade restante que sobrar (leftover_quantity)          
          full_box_count, leftover_quantity = product[:quantity].divmod(product[:ballast])
#Se tiver caixas completas, elas são adicionadas a lista full_boxes e são marcadas como is_full_box: true          
          if full_box_count > 0
            full_box_count.times do
              full_boxes << product.merge(quantity: product[:ballast], is_full_box: true)
            end
          end
#Se tiver quantidade restante que não preencheu uma caixa, ela é adicionada a lista leftovers como um produto separado e marcado como is_full_box: false para alocar no final das camadas         
          if leftover_quantity > 0
            leftovers << product.merge(quantity: leftover_quantity, is_full_box: false)
          end
        end
#Chama o método allocate_layers com a união das listas full_boxes e leftovers, iniciando o processo de alocação em camadas     
        layered_products = allocate_layers(full_boxes + leftovers)
        layered_products
    end
#Método para separar os produtos em full_boxes e leftovers baseado no is_full_box
      def allocate_layers(products)
        layered_products = []
        current_layer = 1
        last_full_box_layer = nil
#Aloca os full_boxes cada um em uma camada diferente
        full_boxes, leftovers = products.partition { |p| p[:is_full_box] }

        full_boxes.each do |product|
          product[:layer] = current_layer
          layered_products << product
#Guarda a ultima camada que recebe de uma caixa completa          
          last_full_box_layer = current_layer
          current_layer += 1
        end
#Tratamento da camada restante, organiza as sobras na mesma camada        
        unless leftovers.empty?
          current_layer = last_full_box_layer + 1 if last_full_box_layer
          leftovers.each do |product|
            existing_product_in_layer = layered_products.find { |p| p[:layer] == current_layer && p[:product_id] == product[:product_id] }
            product[:layer] = current_layer
            layered_products << product
          end
        end
        layered_products
      end
    end
end