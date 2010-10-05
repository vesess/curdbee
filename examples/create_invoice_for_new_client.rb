# In this example we add a new client to your CurdBee account,
# Then create an invoice to him.

require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'curdbee'

# set the API key and subdomain for your account.
CurdBee::Config.api_key = "Your API Key"
CurdBee::Config.subdomain = "Your Subdomain"

begin
  # Create the client
  @client = CurdBee::Client.new(:name => "ABC Inc.",
                                :email => "abc@example.com"
                               )
                               @client.create
  puts "Created the client."

  # Create the invoice
  @invoice = CurdBee::Invoice.new(
    :date => Date.today,
    :due_date => (Date.today + 30),
    :invoice_no => "IN-0001",
    :client_id => @client.id,
    :summary => "Online Presence for the company",
    :line_items_attributes => [{:name_and_description => "Site Revamp", :quantity => 25, :price => 60.00, :unit => "hour"},
                               {:name_and_description => "Domain Registration", :quantity => 10, :price => 10.00, :unit => "domain"}
   ],
    :notes => "Please write a cheque in favour of MyCompany Inc."
    :payment_options => ["paypal", "gcheckout", "twocheckout", "authorizenet"]
  )
  @invoice.create

  puts "Created the invoice"

  # Add a payment 
  @invoice = CurdBee::Invoice.show(@invoice.id)
  CurdBee::Payment.invoice_id = @invoice.id
  @payment = CurdBee::Payment.new(:amount => 70, :date => Date.today, :payment_method => "Manual")
  @payment.create
  puts "Added the payment."

  # Send the invoice
  if @invoice.deliver({'recipients' => [@client.email], 'blind_copy' => "me@example.com"})
    puts "Your invoice was successfully sent to the client."
    #reload the invoice
    @invoice = CurdBee::Invoice.show(@invoice.id)
    puts "To view the invoice visit #{@invoice.permalink}"
  else
    puts "Error sending the invoice."
  end

 rescue => e
   puts "Following error occured - #{e}"
end
