module Fastbillr
  class Customer < Fastbillr::Model

    property :id, from: :CUSTOMER_ID
    fastbill_properties :customer_number, :days_for_payment, :created, :payment_type, :bank_name, :bank_account_number,
      :bank_code, :bank_account_owner, :show_payment_notice, :account_receivable, :customer_type,
      :top, :organization, :position, :salutation, :first_name, :last_name, :address, :address_2,
      :zipcode, :city, :country_code, :phone, :phone_2, :fax, :mobile, :email, :vat_id, :currency_code
        
    # updates a customer or creates a new one
    #
    def save
      Fastbillr::Request.post({"SERVICE" => "customer.update", "DATA" => to_uppercase_attribute_names}.to_json)
    end

    class << self
      def all
        Fastbillr::Request.post('{"SERVICE": "customer.get"}')["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def find_by_id(id)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"CUSTOMER_ID" => id.to_i}}.to_json)
        return false if response["CUSTOMERS"].empty?
        new(response["CUSTOMERS"][0])
      end

      def find_by_customer_number(number)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"CUSTOMER_NUMBER" => number}}.to_json)
        return false if response["CUSTOMERS"].empty?
        new(response["CUSTOMERS"][0])
      end

      def find_by_country(country_code)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"COUNTRY_CODE" => country_code.upcase}}.to_json)
        response["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def search(term)
        response = Fastbillr::Request.post({"SERVICE" => "customer.get", "FILTER" => {"TERM" => term}}.to_json)
        response["CUSTOMERS"].collect { |customer| new(customer) }
      end

      def create(params)
        customer = new(params)
        response = Fastbillr::Request.post({"SERVICE" => "customer.create", "DATA" => customer.to_uppercase_attribute_names}.to_json)
        customer.id = response["CUSTOMER_ID"]
        customer
      end
    end
  end
end
