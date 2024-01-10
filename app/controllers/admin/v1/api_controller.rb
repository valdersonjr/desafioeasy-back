module Admin::V1
    class ApiController < ApplicationController
        private

        def render_error(fields: nil, message: 'Unprocessable Entity', status: :unprocessable_entity)
          render json: { message: message, fields: fields }, status: status
        end
      end
    end
