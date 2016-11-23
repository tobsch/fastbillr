module Fastbillr
  
  class ExpenseVatItem < Fastbillr::Model
    fastbill_properties  :vat_percent, :vat_value, :complete_net
  end
  
  class Expense < Fastbillr::Model
    property :vat_items, :with => lambda { |v| v.collect { |item| ExpenseVatItem.new(item) } }

    property :id, from: :INVOICE_ID

    fastbill_properties :invoice_id, :organization, :invoice_number, :invoice_date, :due_date, :sub_total, :vat_total, 
                        :total, :paid_date, :currency_code, :comment, :vat_items, :payment_info, :note, :comments
    
    def to_hash
      data = super
      data
    end
    
    class << self
      
      def find_by_invoice_id(invoide_id)
        response = request(:get, :FILTER => { :INVOICE_ID => invoide_id })
        return nil if response[model_name_plural.upcase.to_sym].empty?
        new(response[model_name_plural.upcase.to_sym][0])
      end
      
      def find_by_invoice_number(number)
        response = request(:get, :FILTER => { :INVOICE_NUMBER => number })
        return nil if response[model_name_plural.upcase].empty?
        new(response[model_name_plural.upcase.to_sym][0])
      end

      def find_by_month(month)
        response = request(:get, :FILTER => { :MONTH => state })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end

      def find_by_year(year)
        response = request(:get, :FILTER => { :YEAR => year })
        return nil if response[model_name_plural.upcase.to_sym].nil?
        response[model_name_plural.upcase.to_sym].collect { |invoice| new(invoice) }
      end
      
    end
  end
end
