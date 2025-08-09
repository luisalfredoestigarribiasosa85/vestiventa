class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :clothing_items, dependent: :destroy
  has_many :sales, through: :clothing_items, dependent: :destroy

  def total_earnings
    sales.joins(:clothing_item).sum(:price)
  end
end
