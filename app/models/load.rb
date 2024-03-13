# Classe Load (Carga).

class Load < ApplicationRecord                                             
    has_many :orders

    include LikeSearchable                                                 
    include Paginatable                                                    

    validates :code, presence: true, uniqueness: { case_sensitive: false } 
    validates :delivery_date, presence: true                               
end
