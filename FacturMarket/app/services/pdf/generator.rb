# app/services/pdf/generator.rb
# Generador de PDF usando Grover (Chromium) desde una vista HTML.
# Ventaja: puedes diseñar una plantilla ERB en app/views/invoices/pdf.html.erb con CSS
# y Grover generará un PDF fiel al render del navegador.
class Pdf::Generator
  def initialize(invoice)
    @invoice = invoice
  end

  # Retorna el PDF en formato binario
  def call
    html = ApplicationController.render(
      template: "invoices/pdf",
      assigns: { invoice: @invoice },
      layout: "pdf" # usa app/views/layouts/pdf.html.erb
    )

    # Instancia de Grover → usa Chrome sin interfaz gráfica
    grover = Grover.new(html, format: 'A4', margin: { top: '10mm', bottom: '10mm' })
    grover.to_pdf
  end
end
