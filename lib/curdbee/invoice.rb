module CurdBee
 class Invoice < Base

   @resource = "invoices"
   @element = "invoice"

   include CurdBee::Invoiceable

 end
end
