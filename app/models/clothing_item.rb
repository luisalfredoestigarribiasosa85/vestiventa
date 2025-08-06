class ClothingItem < ApplicationRecord
  # belongs_to :user
  has_one :sale
end
