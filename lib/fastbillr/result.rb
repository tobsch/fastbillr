module Fastbillr
  class Result

    class << self
      def process(response)        
        parsed_body = JSON.parse(response.body, { :symbolize_names => true} )
        raise Error, parsed_body[:RESPONSE][:ERRORS] unless response.status == 200
        parsed_body[:RESPONSE]
      end
    end

  end
end
