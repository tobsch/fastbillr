module Fastbillr
  class VatItem < Fastbillr::Model
    fastbill_properties  :vat_percent, :vat_value
  end
  
  class InvoiceItem < Fastbillr::Model
    property :id, from: :INVOICE_ITEM_ID
    fastbill_properties :invoice_item_id, :article_number, :description, :quantity, :unit_price, :vat_percent, :vat_value, 
      :complete_net, :complete_gross, :sort_order
  end
  
  class Invoice < Fastbillr::Model
    property :items, :with => lambda { |v| v.collect { |item| InvoiceItem.new(item) } }
    property :vat_items, :with => lambda { |v| v.collect { |item| VatItem.new(item) } }

    property :id, from: :INVOICE_ID

    fastbill_properties :type, :invoice_number, :customer_id, :customer_costcenter_id, :currency_code, :template_id, :introtext, :invoice_date, :delivery_date,
      :cash_discount_percent, :cash_discount_days, :eu_delivery, :invoice_number, :paid_date, :is_canceled, :due_date, 
      :delivery_date, :sub_total, :vat_total, :total, :document_url
    
    
    # updates an invoice
    #
    def save
      Fastbillr::Request.post({"SERVICE" => "invoice.update", "DATA" => to_uppercase_attribute_names}.to_json)
    end

    class << self
      def all
        Fastbillr::Request.post('{"SERVICE": "invoice.get"}')["INVOICES"].collect { |invoice| new(invoice) }
      end

      def find_by_id(id)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.get", "FILTER" => {"INVOICE_ID" => id.to_i}}.to_json)
        return false if response["INVOICES"].empty?
        new(response["INVOICES"][0])
      end

      def find_by_invoice_number(number)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.get", "FILTER" => {"INVOICE_NUMBER" => number}}.to_json)
        return false if response["INVOICES"].empty?
        new(response["INVOICES"][0])
      end

      def find_by_state(state)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.get", "FILTER" => {"STATE" => state}}.to_json)
        response["INVOICES"].collect { |invoice| new(invoice) }
      end

      def search(term)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.get", "FILTER" => {"TERM" => term}}.to_json)
        response["INVOICES"].collect { |invoice| new(invoice) }
      end

      def create(params)
        invoice = new(params)
        response = Fastbillr::Request.post({"SERVICE" => "invoice.create", "DATA" => invoice.to_uppercase_attribute_names}.to_json)
        invoice.id = response["INVOICE_ID"]
        invoice
      end
    end
  end
end
