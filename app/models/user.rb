class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :clothing_items

  def total_earnings
    clothing_items.where(sold: true).joins(:sale).sum(:price)
  end
end
