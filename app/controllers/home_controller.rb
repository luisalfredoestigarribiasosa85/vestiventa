class HomeController < ApplicationController
  def index
    @clothing_items_count = ClothingItem.count
    @sales_count = Sale.connection.select_value('SELECT COUNT(*) FROM sales').to_i
    @users_count = User.count
    @user = current_user if user_signed_in?
  end
end