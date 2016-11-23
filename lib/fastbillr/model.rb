module Fastbillr
  class Model < Hashie::Trash
    
    def to_hash
      super.inject({}) do |result, (key, value)|
        result[key.upcase] = value
        result
      end
    end
    
    def new_record?
      id == nil
    end
    
    def save
      
      action = new_record? ? :create : :update
      
      response = self.class.request(action, :DATA => to_hash)
      self.id = response["#{self.class.model_name.upcase}_ID"]
      
      self
    end
    
    class << self
      def all
        request(:get)[ model_name_plural.upcase.to_sym ].collect { |invoice| new(invoice) }
      end
      
      def find_by_id(id)
        response = request(:get, :FILTER => { "#{model_name.upcase}_ID" => id.to_i })
        return false if response[model_name_plural.upcase.to_sym].empty?
        new(response[model_name_plural.upcase][0])
      end
      
      def request(action, request_data = {})
        call = { SERVICE: "#{model_name}.#{action}" }.update(request_data)
        response = Fastbillr::Request.post(call.to_json)
        if response.key?('ERRORS')
          raise response['ERRORS'].join(',') + "(call: #{call.inspect})"
        end
        
        response
      end

      def model_name
        name.split('::').last.downcase
      end
      
      # funny plural, as we dont have that tricky model names
      def model_name_plural
        model_name + 's'
      end
      
      def create(params)
        new(params).save
      end
      
      def property(name, options = {})
        options[:from] ||= name.upcase
        super(name, options)
      end
      
      def fastbill_properties(*names)
        names.each do |name|
          property(name)
        end
      end
    end
  end
end