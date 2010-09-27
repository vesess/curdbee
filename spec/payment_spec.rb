require 'spec_helper'

describe CurdBee::Payment do

  describe 'list' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      CurdBee::Payment.invoice_id = 23
    end

    it "should return a list of payments" do
      stub_get "http://test.curdbee.com/invoices/23/payments.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=20", "payments.json"
      result = CurdBee::Payment.list
      result.first.payment_method.should == "cash" 
    end

    it "should raise an error if invoice id is not provided" do
    end
  end

  describe 'show' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      CurdBee::Payment.invoice_id = 23 
    end
   
    it "should return the matching payment" do
      stub_get "http://test.curdbee.com/invoices/23/payments/25.json?api_token=TYMuwW6rM2PQnoWx1ht4", "payment.json"
      result = CurdBee::Payment.show(25)
      result.payment_method.should == "cash" 
    end

    it "should raise an error if invoice id is not provided" do
    end

    it "should raise an error if nothing found" do
      stub_get "http://test.curdbee.com/invoices/23/payments/28.json?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        CurdBee::Payment.show(28)
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'create' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      CurdBee::Payment.invoice_id = 23 
    end
   
    it "should return the created payment" do
      stub_post "http://test.curdbee.com/invoices/23/payments?api_token=TYMuwW6rM2PQnoWx1ht4", "new_payment.json"
      payment_info = {
        :amount => 50,
        :date => Date.today,
        :payment_method => "custom payment",
      }
      @payment = CurdBee::Payment.new(payment_info)
      result = @payment.create
      @payment.id.should == 25 
    end

    it "should raise an error if creation fails" do
      stub_post "http://test.curdbee.com/invoices/23/payments?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @payment = CurdBee::Payment.new({})
        @payment.create
      }.should raise_error(CurdBee::Error::BadRequest)
    end

  end

  describe 'update' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      CurdBee::Payment.invoice_id = 23 

      stub_get "http://test.curdbee.com/invoices/23/payments/25.json?api_token=TYMuwW6rM2PQnoWx1ht4", "payment.json"
      @payment = CurdBee::Payment.show(25)
    end
   
    it "should return the updated payment" do
      stub_put "http://test.curdbee.com/invoices/23/payments/25?api_token=TYMuwW6rM2PQnoWx1ht4", "new_payment.json"
      @payment.payment_method = "custom payment"

      result = @payment.update
      result.should be_true 
    end

    it "should raise an error if update fails" do
      stub_put "http://test.curdbee.com/invoices/23/payments/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422

      lambda{
        @payment.amount = ""
        @payment.update
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'delete' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      CurdBee::Payment.invoice_id = 23 

      stub_get "http://test.curdbee.com/invoices/23/payments/25.json?api_token=TYMuwW6rM2PQnoWx1ht4", "payment.json"
      @payment = CurdBee::Payment.show(25)
    end
   
    it "should return true if payment was deleted" do
      stub_delete "http://test.curdbee.com/invoices/23/payments/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @payment.delete
      result.should be_true 
    end

    it "should raise a bad request error if deletion fails" do
      stub_delete "http://test.curdbee.com/invoices/23/payments/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422 
      lambda{
        @payment.delete
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if payment doesnt exist" do
      stub_delete "http://test.curdbee.com/invoices/23/payments/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404 
      lambda{
        @payment.delete
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

end
