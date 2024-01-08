class Load < ApplicationRecord

    validates :code, presence: true
    validates :delivery_date, presence: true
end
