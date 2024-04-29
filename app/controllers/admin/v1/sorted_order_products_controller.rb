module Admin::V1
  class SortedOrderProductsController < ApiController
    before_action :authenticate_user!
    before_action :set_order, only: [:index, :show_sorted_products]

    def index
      order_products = @order.order_products
      sorted_products = sort_order_products(order_products)
      layered_products = build_layers(sorted_products)
      save_sorted_products(layered_products)
      render json: layered_products, status: :ok
    end
#Método para visualização dos produtos ordenados
    def show_sorted_products
      sorted_order_products = SortedOrderProduct.where(order_id: params[:order_id])
      render json: sorted_order_products.as_json(include: {
        product: {
          only: [:name, :ballast]
        }
      }, only: [:quantity, :box, :layer]), status: :ok
    end

    def sort_all
      threads = []
    
      Order.includes(order_products: :product).find_each(batch_size: 200) do |order|
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            order_products = order.order_products
            sorted_products = sort_order_products(order_products)
            layered_products = build_layers(sorted_products)
            save_sorted_products(layered_products)
          end
        end
        if threads.size >= 2
          threads.each(&:join)
          threads = []
        end
      end
      threads.each(&:join)
    end

    private
#Método para excluir os registros antes de ordenar
    def clear_sorted_products
      SortedOrderProduct.delete_all
    end

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
    end.sort_by { |product| [product[:box] ? 0 : 1, -product[:quantity]] }
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
    if product[:box]
      full_box_count.times do
      full_boxes << product.merge(quantity: product[:ballast], is_full_box: true)
    end
#Se tiver quantidade restante que não preencheu uma caixa, ela é adicionada a lista leftovers como um produto separado e marcado como is_full_box: false para alocar no final das camadas      
    if leftover_quantity > 0
      leftovers << product.merge(quantity: leftover_quantity, is_full_box: false)
    end
  else
#Se não for uma caixa, a quantidade inteira fica marcada como leftover
    leftovers << product.merge(quantity: product[:quantity], is_full_box: false)
  end
end
#Combina e ordena a lista final antes da alocação por camadas para manter box true antes de false na exibição da lista
      final_products = (full_boxes + leftovers).sort_by { |p| [p[:box] ? 0 : 1, -p[:quantity]] }
      layered_products = allocate_layers(final_products)
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
        last_full_box_layer = current_layer
        current_layer += 1
      end
#Tratamento da camada restante, organiza as sobras na mesma camada        
      unless leftovers.empty?
        if last_full_box_layer
          current_layer = last_full_box_layer + 1
        end
        leftovers.each do |product|
          product[:layer] = current_layer
          layered_products << product
        end
      end
      layered_products
    end
#Método para salvar os produtos ordenados    
def save_sorted_products(sorted_products)
  #Inicia uma transação no banco de dados      
        ActiveRecord::Base.transaction do
  #Itera sobre cada produto no array de produtos ordenados        
          sorted_products.each do |product_data|
  #Busca ou inicializa um registro de SortedOrderProduct com os critérios específicos          
            sorted_product = SortedOrderProduct.find_or_initialize_by(
              product_id: product_data[:product_id],
              order_id: product_data[:order_id],
              layer: product_data[:layer],
              quantity: product_data[:quantity],
              box: product_data[:box]
            )
  #Salva o registro no banco de dados levantando uma exceção se falhar          
            sorted_product.save!
          end
        rescue ActiveRecord::RecordInvalid => e
          logger.error("Erro ao carregar a lista de sorted order products: #{e.message}")
        end
      end
    end
  end