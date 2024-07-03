class User < ApplicationRecord
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :posts
  has_many :comments

  def author?
    roles.exists?(name: 'author')
  end

  def lector?
    roles.exists?(name: 'lector')
  end

  def admin?
    roles.exists?(name: 'admin')
  end

  def daily_comment_limit
    comment_limit || 2 # Valor por defecto de 2 si no está configurado
  end
end
