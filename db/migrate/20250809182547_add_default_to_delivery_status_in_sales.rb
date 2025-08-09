class AddDefaultToDeliveryStatusInSales < ActiveRecord::Migration[8.0]
  def change
    change_column_default :sales, :delivery_status, from: nil, to: :pending
    Sale.where(delivery_status: nil).update_all(delivery_status: :pending)
  end
end
