json.extract! sale, :id, :clothing_item_id, :buyer_name, :address, :delivery_status, :created_at, :updated_at
json.url sale_url(sale, format: :json)
