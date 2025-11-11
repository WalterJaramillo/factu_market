json.extract! invoice, :id, :series, :number, :issuer_nit, :issuer_name, :receiver_nit, :receiver_name, :issue_date, :subtotal, :total, :vat, :status, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
