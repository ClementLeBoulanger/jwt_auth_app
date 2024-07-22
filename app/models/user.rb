class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  # Ajoute les attributs supplémentaires pour le prénom et le nom
  # validates :first_name, :last_name, presence: true
end
