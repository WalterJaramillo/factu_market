# app/controllers/invoices_controller.rb
class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy issue download_pdf download_json]

  # GET /invoices
  def index
    @invoices = Invoice.order(created_at: :desc).includes(:line_items).page(params[:page])
  end

  # GET /invoices/1
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.line_items.build
    
    # Consumir la API de clientes
    @clients = ClientsApi.all.parsed_response # Devuelve un array de hashes
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  
def create
  @invoice = Invoice.new(invoice_params)

  if @invoice.save
    InvoiceMailer.with(invoice: @invoice).invoice_email.deliver_now

    # Generar PDF con Grover
    html = "<h1>Factura generada</h1><p>ID: #{@invoice.id}</p>"
    pdf = Grover.new(html).to_pdf

    @invoice.pdf_file.attach(
      io: StringIO.new(pdf),
      filename: "invoice_#{@invoice.id}.pdf",
      content_type: 'application/pdf'
    )

    

    redirect_to rails_blob_path(@invoice.pdf_file, disposition: 'attachment')
  else
    @invoices = Invoice.all
    render :index
  end
end



  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: "Factura actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy
    redirect_to invoices_url, notice: "Factura eliminada correctamente"
  end

  # POST /invoices/1/issue
  def issue
    begin
      @invoice.issue!
      redirect_to @invoice, notice: "Factura marcada como emitida y encolada para generación/envío."
    rescue => e
      redirect_to @invoice, alert: "Error al emitir: #{e.message}"
    end
  end

  # GET /invoices/1/download_pdf
  def download_pdf
    if @invoice.pdf_file.attached?
      redirect_to rails_blob_url(@invoice.pdf_file, disposition: "attachment")
    else
      head :not_found
    end
  end

  # GET /invoices/1/download_json
  def download_json
    if @invoice.json_file.attached?
      redirect_to rails_blob_url(@invoice.json_file, disposition: "attachment")
    else
      head :not_found
    end
  end

  private

  # Busca la factura por ID
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  # Permite los parámetros seguros del formulario
  def invoice_params
    params.require(:invoice).permit(
      :series, :number, :issuer_nit, :issuer_name, :receiver_nit, :receiver_name, :receiver_id,
      :issue_date, :subtotal, :vat, :total, :status,
      line_items_attributes: [:id, :description, :quantity, :price, :subtotal, :_destroy]
    )
  end
end
