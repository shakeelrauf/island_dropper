class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  has_many :deliveries , dependent: :destroy 

  scoped_search on: [:first_name,:last_name]
  has_and_belongs_to_many :roles, join_table: 'users_roles'


  def role
    self.roles.first.title
  end

  def full_name
    "#{self.first_name } "+"#{ self.last_name}"
  end
end
