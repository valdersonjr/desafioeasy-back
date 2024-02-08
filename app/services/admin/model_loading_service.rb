# Serviço para manipular consultas comuns de listagem de registros que incluem pesquisa, ordenação e paginação. 

module Admin  
    class ModelLoadingService
      attr_reader :records, :pagination                                                        # Permite acesso de leitura aos registros carregados e informações de paginação.
  
      def initialize(searchable_model, params = {})
        @searchable_model = searchable_model                                                   # Modelo ActiveRecord que será consultado.
        @params = params || {}                                                                 # Parâmetros de pesquisa e paginação.
        @records = []                                                                          # Array para armazenar os registros resultantes da pesquisa.
        @pagination = {}                                                                       # Hash para armazenar informações sobre a paginação dos registros.
      end
  
      def call
        set_pagination_values                                                                  # Ajusta os valores de paginação com base nos parâmetros fornecidos.
        searched = search_records(@searchable_model)                                           # Aplica filtros de pesquisa aos registros.
        order_params = @params[:order].to_h.presence || { id: :asc }                           # Determina os parâmetros de ordenação.                      
        @records = searched.order(order_params)                                                # Aplica ordenação e paginação aos registros e atualiza @records.
                           .paginate(@params[:page], @params[:length])
        set_pagination_attributes(searched.count)                                              # Configura os atributos de paginação com base no total de registros filtrados.
      end
#   --MÉTODOS PRIVADOS--  
      private
  
      def set_pagination_values                                                                # Converte os parâmetros de paginação para inteiros e aplica valores padrão se necessário.
        @params[:page] = @params[:page].to_i
        @params[:length] = @params[:length].to_i
        @params[:page] = @searchable_model.model::DEFAULT_PAGE if @params[:page] <= 0          # Aplica valores padrão de paginação do modelo caso os parâmetros sejam inválidos (<= 0).
        @params[:length] = @searchable_model.model::MAX_PER_PAGE if @params[:length] <= 0
      end
  
      def search_records(searched)                        
        return searched unless @params.has_key?(:search)                                       # Retorna os registros sem alterações se não houver parâmetros de pesquisa.
        @params[:search].each do |key, value|                                                  # Aplica filtros de busca 'like' para cada parâmetro de pesquisa fornecido.
          searched = searched.like(key, value)
        end
        searched
      end
  
      def set_pagination_attributes(total_filtered)
        total_pages = (total_filtered / @params[:length].to_f).ceil                            # Calcula o total de páginas com base na contagem total de registros filtrados e no comprimento da página.
        @pagination.merge!(page: @params[:page], length: @records.count,                       # Atualiza o hash de paginação com a página atual, quantidade de registros por página, total de registros e total de páginas.
                           total: total_filtered, total_pages: total_pages)
      end
    end
  end