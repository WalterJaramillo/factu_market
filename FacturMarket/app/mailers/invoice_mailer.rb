# app/mailers/invoice_mailer.rb
class InvoiceMailer < ApplicationMailer
  def invoice_email
    @invoice = params[:invoice]

    # Obtenemos el cliente desde el microservicio .NET
    response = ClientsApi.find(@invoice.receiver_id)

    # Parseamos el JSON que viene del microservicio
    if response.success?
      client_data = response.parsed_response
      client_email = client_data["email"]

      # Adjuntamos el PDF si existe
      if @invoice.pdf_file.attached?
        attachments[@invoice.pdf_file.filename.to_s] = @invoice.pdf_file.download
      end

      mail(to: client_email, subject: "Factura ##{@invoice.id}")
    else
      Rails.logger.error("No se pudo obtener el cliente #{@invoice.client_id} del microservicio. Respuesta: #{response.inspect}")
    end
  end
end
