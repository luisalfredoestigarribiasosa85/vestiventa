class NormalizeSaleDeliveryStatus < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE sales
      SET delivery_status = CASE COALESCE(delivery_status, '')
        WHEN '' THEN 'pending'
        WHEN '0' THEN 'pending'
        WHEN '1' THEN 'in_transit'
        WHEN '2' THEN 'delivered'
        ELSE delivery_status
      END
    SQL
  end

  def down
    execute <<~SQL
      UPDATE sales
      SET delivery_status = CASE COALESCE(delivery_status, '')
        WHEN 'pending' THEN '0'
        WHEN 'in_transit' THEN '1'
        WHEN 'delivered' THEN '2'
        ELSE delivery_status
      END
    SQL
  end
end
