module Fastbillr
  class Configuration

    class << self
      attr_accessor :email, :api_key

      def configure
        yield self
      end

      def base_url
        "https://my.fastbill.com/api/1.0/api.php"
      end
    end

  end
end
