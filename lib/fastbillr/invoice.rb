module Fastbillr
  class VatItem < Fastbillr::Model
    fastbill_properties  :vat_percent, :vat_value
  end
  
  class InvoiceItem < Fastbillr::Model
    property :id, from: :INVOICE_ITEM_ID
    fastbill_properties :article_number, :description, :quantity, :unit_price, :vat_percent, :vat_value, 
      :complete_net, :complete_gross, :sort_order
  end
  
  class Invoice < Fastbillr::Model
    property :items, :with => lambda { |v| v.collect { |item| InvoiceItem.new(item) } }
    property :vat_items, :with => lambda { |v| v.collect { |item| VatItem.new(item) } }

    property :id, from: :INVOICE_ID

    fastbill_properties :type, :invoice_number, :customer_id, :customer_costcenter_id, :currency_code, :template_id, :introtext, :invoice_date, :delivery_date,
      :cash_discount_percent, :cash_discount_days, :eu_delivery, :invoice_number, :paid_date, :is_canceled, :due_date, 
      :delivery_date, :sub_total, :vat_total, :total, :document_url
    
    def send_by_email(recipient, options = {})
      data = options.inject({}){ |memo, (k,v)| memo[k.to_s.upcase] = v; memo }
      data['INVOICE_ID'] = id
      data['RECIPIENT'] = recipient
      response = self.class.request('sendbyemail', :DATA => data)
    end
    
    def complete
      response = self.class.request('complete', :DATA => { :INVOICE_ID => id })
    end
      
    def to_hash
      data = super
      items = data.delete 'ITEMS'
      
      data[:ITEMS] = { :ITEM => items }
      
      data
    end
    
    class << self
      def find_by_invoice_number(number)
        response = request(:get, :FILTER => { :INVOICE_NUMBER => number })
        return false if response[model_name_plural.upcase].empty?
        new(response[model_name_plural.upcase][0])
      end

      def find_by_state(state)
        response = request(:get, :FILTER => { :STATE => state })
        return false if response[model_name_plural.upcase].empty?
        response[model_name_plural.upcase].collect { |invoice| new(invoice) }
      end

      def search(term)
        response = request(:get, :FILTER => { :TERM => term })
        return false if response[model_name_plural.upcase].empty?
        response[model_name_plural.upcase].collect { |invoice| new(invoice) }
      end
    end
  end
end
