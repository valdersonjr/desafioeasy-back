class Load < ApplicationRecord
    include LikeSearchable
    include Paginatable
    validates :code, presence: true
    validates :code, presence: true, uniqueness: { case_sensitive: false }
    validates :delivery_date, presence: true
end
