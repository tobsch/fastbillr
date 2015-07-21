module Fastbillr
  class InvoiceVatItem < Fastbillr::Model
    fastbill_properties  :vat_percent, :vat_value, :complete_net
  end
  
  class InvoiceItem < Fastbillr::Model
    property :id, from: :INVOICE_ITEM_ID
    fastbill_properties :article_number, :description, :quantity, :unit_price, :vat_percent, :vat_value, 
      :complete_net, :complete_gross, :sort_order
  end
  
  class Invoice < Fastbillr::Model
    property :items, :with => lambda { |v| v.collect { |item| InvoiceItem.new(item) } }
    property :vat_items, :with => lambda { |v| v.collect { |item| InvoiceVatItem.new(item) } }

    property :id, from: :INVOICE_ID

    fastbill_properties :type, :invoice_number, :customer_id, :customer_costcenter_id, :currency_code, :template_id, :introtext, :invoice_date, :delivery_date,
      :cash_discount_percent, :cash_discount_days, :eu_delivery, :invoice_number, :paid_date, :is_canceled, :due_date, 
      :delivery_date, :sub_total, :vat_total, :total, :document_url, :customer_number, :project_id, 
      :invoice_title, :organization, :note, :salutation,
      :first_name, :last_name, :address, :address_2, :zipcode, :city, :comment_ , :payment_type, :days_for_payment, :bank_name, :bank_account_number, :bank_code, :bank_account_owner, 
      :bank_iban, :bank_bic, :affiliate, :country_code, :vat_id, :currency_code, :subscription_id, :payment_info, :lastupdate
      
    def to_hash
      data = super
      
      items = data.delete :ITEMS
      
      data[:ITEMS] = { :ITEM => items }
      
      data
    end
    
    class << self
      
      def find_by_invoice_number(number)
        response = request(:get, :FILTER => { :INVOICE_NUMBER => number })
        return nil if response[model_name_plural.upcase.to_sym].empty?
        new(response[model_name_plural.upcase][0])
      end
      
      # outgoing = Rechnungen draft = Entwürfe | credit = Gutschriften
      def find_by_type(state)
        response = request(:get, :FILTER => { :TYPE => state })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
      def find_by_title(title)
        response = request(:get, :FILTER => { :TITLE => title })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
      def find_by_customer_id(customer_id)
        response = request(:get, :FILTER => { :CUSTOMER_ID => customer_id })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
      def find_by_month(month)
        response = request(:get, :FILTER => { :MONTH => month })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
      def find_by_year(year)
        response = request(:get, :FILTER => { :YEAR => year })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
      def find_by_start_due_date(start_due_date)
        response = request(:get, :FILTER => { :START_DUE_DATE => start_due_date })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
      def find_by_end_due_date(end_due_date)
        response = request(:get, :FILTER => { :END_DUE_DATE => end_due_date })
        return false if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end

      def search(term)
        response = request(:get, :FILTER => { :TERM => term })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
    end
  end
end
