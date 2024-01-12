class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include LikeSearchable
  include Paginatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :login, presence: true

  validates :login, presence: true, uniqueness: { case_sensitive: false }
    
  validates :name, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  
end