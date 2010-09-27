require 'spec_helper'

describe CurdBee::Invoice do

  describe 'list' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end

    it "should return a list of invoices" do
      stub_get "http://test.curdbee.com/invoices.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=20", "invoices.json"
      result = CurdBee::Invoice.list
      result.first.invoice_no.should == "TEST-1" 
    end

    it "should take limit as an option" do
      stub_get "http://test.curdbee.com/invoices.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=1", "invoices.json"
      result = CurdBee::Invoice.list(:limit => 1)
      result.length.should == 1 
    end

    it "should take page as an option" do
      stub_get "http://test.curdbee.com/invoices.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=2&per_page=1", "invoices.json"
      result = CurdBee::Invoice.list(:limit => 1, :page => 2)
      result.length.should == 1 
    end
  end

  describe 'show' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the matching invoice" do
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      result = CurdBee::Invoice.show(31)
      result.invoice_no.should == "TEST-1" 
    end

    it "should raise an error if nothing found" do
      stub_get "http://test.curdbee.com/invoices/32.json?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        CurdBee::Invoice.show(32)
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'create' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the created invoice" do
      stub_post "http://test.curdbee.com/invoices?api_token=TYMuwW6rM2PQnoWx1ht4", "new_invoice.json"
      invoice_info = {:date => Date.today, :invoice_no => "IN-NEW", :client_id => @client.id,
                      :line_items_attributes => [{:name_and_description => "Sample Item", :quantity => 1, :price => 25.00, :unit => "hour"}]
                     }
      puts invoice_info.to_xml(:root => 'invoice')
      @invoice = CurdBee::Invoice.new(invoice_info)
      result = @invoice.create
      @invoice.id.should == 32 
    end

    it "should raise an error if creation fails" do
      stub_post "http://test.curdbee.com/invoices?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice = CurdBee::Invoice.new({})
        @invoice.create
      }.should raise_error(CurdBee::Error::BadRequest)
    end

  end

  describe 'update' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
    end
   
    it "should return the updated invoice" do
      stub_put "http://test.curdbee.com/invoices/31?api_token=TYMuwW6rM2PQnoWx1ht4", "new_invoice.json"
      
      @invoice.invoice_no = "IN-NEW"
      @invoice.date = Date.today

      result = @invoice.update
      result.should be_true 
    end

    it "should raise an error if update fails" do
      stub_put "http://test.curdbee.com/invoices/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice.invoice_no = ""
        @invoice.update
      }.should raise_error(CurdBee::Error::BadRequest)
    end

  end

  describe 'delete' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
   end
   
    it "should return true if invoice was deleted" do
      stub_delete "http://test.curdbee.com/invoices/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @invoice.delete
      result.should == true 
    end

    it "should raise a bad request error if deletion fails" do
      stub_delete "http://test.curdbee.com/invoices/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice.delete
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if invoice doesnt exist" do
      stub_delete "http://test.curdbee.com/invoices/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @invoice.delete
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'duplicate' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
    end
   
    it "should return the duplicated invoice if invoice was duplicated" do
      stub_post "http://test.curdbee.com/invoices/31/duplicate?api_token=TYMuwW6rM2PQnoWx1ht4", "new_invoice.json"
      result = @invoice.duplicate
      result.invoice_no.should == "IN-NEW" 
    end

    it "should raise a bad request error if duplication fails" do
      stub_post "http://test.curdbee.com/invoices/31/duplicate?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice.duplicate
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if invoice doesnt exist" do
      stub_post "http://test.curdbee.com/invoices/31/duplicate?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @invoice.duplicate
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'close' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
    end
   
    it "should return true if invoice was closed" do
      stub_post "http://test.curdbee.com/invoices/31/close?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @invoice.close
      result.should == true 
    end

    it "should raise a bad request error if closing fails" do
      stub_post "http://test.curdbee.com/invoices/31/close?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice.close
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if invoice doesnt exist" do
      stub_post "http://test.curdbee.com/invoices/31/close?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @invoice.close
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'reopen' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
    end
   
    it "should return true if invoice was reopened" do
      stub_post "http://test.curdbee.com/invoices/31/reopen?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @invoice.reopen
      result.should == true 
    end

    it "should raise a bad request error if reopening fails" do
      stub_post "http://test.curdbee.com/invoices/31/reopen?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice.reopen
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if invoice doesnt exist" do
      stub_post "http://test.curdbee.com/invoices/31/reopen?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @invoice.reopen
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'deliver' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
    end
   
    it "should return true if invoice was delivered" do
      stub_post "http://test.curdbee.com/deliver/invoice/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @invoice.deliver
      result.should == true 
    end

    it "should raise a bad request error if sending fails" do
      stub_post "http://test.curdbee.com/deliver/invoice/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @invoice.deliver
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if invoice doesnt exist" do
      stub_post "http://test.curdbee.com/deliver/invoice/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @invoice.deliver
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'permalink' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/invoices/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "invoice.json"
      @invoice = CurdBee::Invoice.show(31)
    end
   
    it "should return the permalink to view a sent invoice" do
      @invoice.permalink.should == "http://test.curdbee.com/inv/tx9045ff"
    end

    it "should return nothing for draft invoices" do
      @new_invoice = CurdBee::Invoice.new()
      @new_invoice.permalink.should == ""
    end
  end

end
