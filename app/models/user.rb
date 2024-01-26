class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include LikeSearchable
  include Paginatable

  devise :database_authenticatable, :registerable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :login, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def self.next_available_id
    used_ids = User.order(:id).pluck(:id)
    return 1 if used_ids.empty?
    (1..used_ids.last).each do |id|
      return id unless used_ids.include?(id)
    end
    used_ids.last + 1
  end
end