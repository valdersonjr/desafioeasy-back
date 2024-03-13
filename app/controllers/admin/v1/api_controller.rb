# Parte da API que renderiza a mensagem de erro na criação de usuários, produtos ou cargas após ser verificado se preencheu todos requisitos ou se o objeto já existe.
module Admin::V1
    class ApiController < ApplicationController
        private
        def render_error(fields: nil, message: 'Não foi possível criar, os parâmetros são inválidos ou o objeto já existe!', status: :unprocessable_entity)
          render json: { message: message, fields: fields }, status: status
        end
      end
    end
