json.extract! line_item, :id, :invoice_id, :description, :quantity, :price, :subtotal, :created_at, :updated_at
json.url line_item_url(line_item, format: :json)
