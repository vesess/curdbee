require 'crack'

module CurdBee
  class Parser < HTTParty::Parser

    def parse
      begin
        Crack::JSON.parse(body)
      rescue => e
        raise(CurdBee::Error::UnexpectedResponse.new(e.message), body)
      end
    end

  end
end
