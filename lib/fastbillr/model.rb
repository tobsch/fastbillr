module Fastbillr
  class Model < Hashie::Trash
    def to_uppercase_attribute_names
      self.to_hash.inject({}) do |result, (key, value)|
        result[key.upcase] = value
        result
      end
    end
    
    
    class << self
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