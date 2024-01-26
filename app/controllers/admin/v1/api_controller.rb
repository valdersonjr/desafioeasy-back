module Admin::V1
    class ApiController < ApplicationController
        private

        def render_error(fields: nil, message: 'Não foi possivel criar, os parâmetros são inválidos!', status: :unprocessable_entity)
          render json: { message: message, fields: fields }, status: status
        end
      end
    end
