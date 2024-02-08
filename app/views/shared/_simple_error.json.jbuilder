# bloco específico estrutura uma resposta JSON que contém informações de erro, incluindo detalhes sobre os campos com erro e a mensagem de erro.

json.errors do                                                     # Define um objeto JSON chamado "errors".
  json.fields fields if defined?(fields) && fields.present?        # `json.fields fields` adiciona um elemento chamado "fields" dentro do objeto "errors",
                                                                   # contendo os detalhes dos campos que tiveram erro. Isso só ocorre se a variável `fields`
                                                                   # estiver definida e não estiver vazia. A condição `defined?(fields) && fields.present?`
                                                                   # verifica se `fields` é definida e possui algum valor.

  json.message message if defined?(message) && message.present?    # `json.message message` adiciona um elemento chamado "message" dentro do objeto "errors",
                                                                   # contendo a mensagem de erro. Isso só ocorre se a variável `message`
                                                                   # estiver definida e não estiver vazia. A condição `defined?(message) && message.present?`
                                                                   # verifica se `message` é definida e possui algum valor. 
end