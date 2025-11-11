# app/services/ubl/ubl_builder.rb
# Builds a minimal UBL 2.1 XML (skeleton) for DIAN.
# Usage: xml_str = Ubl::UblBuilder.new(invoice).build
#
# Note: this class builds a sample XML with the required fields.
# To be fully compliant with DIAN, review the Technical Annex and
# add the DianExtensions namespace elements and CUFE generation.
#
# DIAN documentation: https://www.dian.gov.co/...
require 'builder'

module Ubl
  class UblBuilder
    def initialize(invoice)
      @invoice = invoice
    end

    def build
      xml = Builder::XmlMarkup.new(indent: 2)
      # XML header and UBL 2.1 namespaces
      xml.instruct! :xml, encoding: "UTF-8"
      xml.Invoice(
        "xmlns" => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
        "xmlns:cac" => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
        "xmlns:cbc" => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
        "xmlns:ext" => "urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2",
        "xmlns:ds" => "http://www.w3.org/2000/09/xmldsig#"
      ) do
        # UBL extensions (DIAN uses a DianExtensions container)
        xml["ext"].UBLExtensions do
          xml["ext"].UBLExtension do
            xml["ext"].ExtensionContent do
              # DIAN-specific elements (CUFE, signature, etc.) go here.
              # Leave empty for now.
            end
          end
        end

        # Basic info
        xml["cbc"].UBLVersionID "2.1"
        xml["cbc"].CustomizationID "1" # example; DIAN may require a specific customization ID
        xml["cbc"].ID "#{@invoice.series}-#{@invoice.number}"
        xml["cbc"].IssueDate @invoice.issue_date.iso8601
        xml["cbc"].InvoiceTypeCode "01" # 01 = sales invoice (DIAN catalog)
        xml["cbc"].DocumentCurrencyCode "COP"

        # Supplier (Issuer)
        xml["cac"].AccountingSupplierParty do
          xml["cac"].Party do
            xml["cac"].PartyIdentification do
              xml["cbc"].ID @invoice.issuer_nit
            end
            xml["cac"].PartyName do
              xml["cbc"].Name @invoice.issuer_name
            end
          end
        end

        # Customer (Receiver)
        xml["cac"].AccountingCustomerParty do
          xml["cac"].Party do
            xml["cac"].PartyIdentification do
              xml["cbc"].ID @invoice.receiver_nit
            end
            xml["cac"].PartyName do
              xml["cbc"].Name @invoice.receiver_name
            end
          end
        end

        # Monetary totals
        xml["cac"].LegalMonetaryTotal do
          xml["cbc"].LineExtensionAmount(format_amount(@invoice.subtotal), currencyID: "COP")
          xml["cbc"].TaxExclusiveAmount(format_amount(@invoice.subtotal), currencyID: "COP")
          xml["cbc"].TaxInclusiveAmount(format_amount(@invoice.total), currencyID: "COP")
          xml["cbc"].PayableAmount(format_amount(@invoice.total), currencyID: "COP")
        end

        # Tax totals
        xml["cac"].TaxTotal do
          xml["cbc"].TaxAmount(format_amount(@invoice.vat), currencyID: "COP")
          xml["cac"].TaxSubtotal do
            xml["cbc"].TaxableAmount(format_amount(@invoice.subtotal), currencyID: "COP")
            xml["cbc"].TaxAmount(format_amount(@invoice.vat), currencyID: "COP")
            xml["cac"].TaxCategory do
              xml["cac"].TaxScheme do
                xml["cbc"].ID "01" # VAT
                xml["cbc"].Name "IVA"
              end
            end
          end
        end

        # Line items
        @invoice.line_items.each_with_index do |li, index|
          xml["cac"].InvoiceLine do
            xml["cbc"].ID (index + 1).to_s
            xml["cbc"].InvoicedQuantity(li.quantity, unitCode: "EA")
            xml["cbc"].LineExtensionAmount(format_amount(li.subtotal), currencyID: "COP")

            xml["cac"].Item do
              xml["cbc"].Description li.description
            end

            xml["cac"].Price do
              xml["cbc"].PriceAmount(format_amount(li.price), currencyID: "COP")
            end
          end
        end
      end

      xml.target!
    end

    private

    def format_amount(value)
      format('%.2f', value.to_f)
    end
  end
end
