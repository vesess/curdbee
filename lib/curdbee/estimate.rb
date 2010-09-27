module CurdBee
 class Estimate < Base
   @resource = "estimates"
   @element = "estimate"

   include CurdBee::Invoiceable

   def convert
     response = self.class.send_request(:post, "/#{self.class.resource}/#{self[:id]}/convert")
     self.class.new(response["invoice"])
   end

 end
end
