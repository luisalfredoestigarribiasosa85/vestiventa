class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    @available_count = current_user.clothing_items.available_for_sale.count
    @sold_count = current_user.clothing_items.where(sold: true).count
    @total_earnings = current_user.total_earnings
    @in_transit_count = current_user.sales.delivery_status_in_transit.count
    @sales_count = current_user.sales.count
    @recent_sales = current_user.sales.includes(:clothing_item).recent.limit(6)
    @available_items = current_user.clothing_items.available_for_sale.order(created_at: :desc).limit(4)
  end
end
