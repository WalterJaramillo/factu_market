# app/services/clients_api.rb
require 'httparty'

class ClientsApi
  include HTTParty
  base_uri 'http://localhost:5105'  

  # GET /clients
  def self.all
    get('/clients')
  end

  # GET /clients/{id}
  def self.find(id)
    get("/clients/#{id}")
  end

  # POST /clients
  def self.create(params)
    post('/clients', body: params.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  # PUT /clients/{id}
  def self.update(id, params)
    put("/clients/#{id}", body: params.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  # DELETE /clients/{id}
  def self.destroy(id)
    delete("/clients/#{id}")
  end
end
