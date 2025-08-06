class HomeController < ApplicationController
  def index
    @clothing_items = ClothingItem.all
    @user = current_user if user_signed_in?
  end
end