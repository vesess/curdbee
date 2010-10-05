module CurdBee
  module Invoiceable

    # common methods for invoices and estimates

    def duplicate
     response = self.class.send_request(:post, "/#{self.class.resource}/#{self[:id]}/duplicate")
     self.class.new(response["#{self.class.element}"])
    end

    def close
     response = self.class.send_request(:post, "/#{self.class.resource}/#{self[:id]}/close")
     return true if response.code.to_i == 200
    end

    def reopen
     response = self.class.send_request(:post, "/#{self.class.resource}/#{self[:id]}/reopen")
     return true if response.code.to_i == 200
    end

    def deliver(send_list={}) 
     body = {:delivery => send_list}.to_json
     response = self.class.send_request(:post, "/deliver/#{self.class.element}/#{self[:id]}", :body => body)
     return true if response.code.to_i == 200
    end

    def permalink
     statement_type = self.class.element == "estimate" ? "est" : "inv"
     unless self.hash_key.nil? || self.hash_key.empty?
       "#{self.class.base_uri}/#{statement_type}/#{self.hash_key}" 
     else
       ""
     end
    end
 end
end
