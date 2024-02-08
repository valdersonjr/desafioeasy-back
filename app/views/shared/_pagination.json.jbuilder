# Jbuilder usado para adicionar paginação a uma resposta JSON.

json.page pagination[:page]                    # O valor é obtido de `pagination[:page]`, que é um hash contendo informações sobre a paginação da coleção de objetos que estão sendo retornados.
json.length pagination[:length]                # O valor é extraído de `pagination[:length]`, indicando quantos itens existem por página. 
json.total pagination[:total]                  # O valor é retirado de `pagination[:total]`, que informa o número total de itens disponíveis na coleção antes da aplicação da paginação.
json.total_pages pagination[:total_pages]      # Este valor vem de `pagination[:total_pages]`, calculado com base no total de registros disponíveis e no número de registros por página, indicando quantas páginas de dados existem.