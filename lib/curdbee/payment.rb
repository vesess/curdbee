module CurdBee
 class Payment < Base

   class << self; 
     def invoice_id=(value)
       @invoice_id = value
       self.resource = "invoices/#{@invoice_id}/payments"
      end

      def invoice_id
        @invoice_id
      end
   end
 
   @element = "payment"

 end
end
