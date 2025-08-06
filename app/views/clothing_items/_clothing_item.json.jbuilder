json.extract! clothing_item, :id, :name, :size, :color, :price, :user_id, :sold, :created_at, :updated_at
json.url clothing_item_url(clothing_item, format: :json)
