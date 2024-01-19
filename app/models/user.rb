class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include LikeSearchable
  include Paginatable

  devise :database_authenticatable, :registerable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :login, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end