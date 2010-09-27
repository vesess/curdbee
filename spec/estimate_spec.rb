require 'spec_helper'

describe CurdBee::Estimate do

  describe 'list' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end

    it "should return a list of estimates" do
      stub_get "http://test.curdbee.com/estimates.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=20", "estimates.json"
      result = CurdBee::Estimate.list
      result.first.estimate_no.should == "TEST-1" 
    end

    it "should take limit as an option" do
      stub_get "http://test.curdbee.com/estimates.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=1", "estimates.json"
      result = CurdBee::Estimate.list(:limit => 1)
      result.length.should == 1 
    end

    it "should take page as an option" do
      stub_get "http://test.curdbee.com/estimates.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=2&per_page=1", "estimates.json"
      result = CurdBee::Estimate.list(:limit => 1, :page => 2)
      result.length.should == 1 
    end
  end

  describe 'show' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the matching estimate" do
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      result = CurdBee::Estimate.show(31)
      result.estimate_no.should == "TEST-1" 
    end

    it "should raise an error if nothing found" do
      stub_get "http://test.curdbee.com/estimates/32.json?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        CurdBee::Estimate.show(32)
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'create' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the created estimate" do
      stub_post "http://test.curdbee.com/estimates?api_token=TYMuwW6rM2PQnoWx1ht4", "new_estimate.json"
      estimate_info = {:date => Date.today, :estimate_no => "EST-NEW", :client_id => @client.id,
                      :line_items_attributes => [{:name_and_description => "Sample Item", :quantity => 1, :price => 25.00, :unit => "hour"}]
                     }
      @estimate = CurdBee::Estimate.new(estimate_info)
      result = @estimate.create
      @estimate.id.should == 31 
    end

    it "should raise an error if creation fails" do
      stub_post "http://test.curdbee.com/estimates?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate = CurdBee::Estimate.new({})
        @estimate.create
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'update' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return the updated estimate" do
      stub_put "http://test.curdbee.com/estimates/31?api_token=TYMuwW6rM2PQnoWx1ht4", "new_estimate.json"
      @estimate.estimate_no = "EST-NEW"
      @estimate.date = Date.today

      result = @estimate.update
      result.should be_true 
    end

    it "should raise an error if update fails" do
      stub_put "http://test.curdbee.com/estimates/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.estimate_no = ""
        @estimate.update
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'delete' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return true if estimate was deleted" do
      stub_delete "http://test.curdbee.com/estimates/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @estimate.delete
      result.should be_true 
    end

    it "should raise a bad request error if deletion fails" do
      stub_delete "http://test.curdbee.com/estimates/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.delete
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if estimate doesnt exist" do
      stub_delete "http://test.curdbee.com/estimates/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @estimate.delete
      }.should raise_error(CurdBee::Error::NotFound)
    end


  end

  describe 'duplicate' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return the duplicated estimate if it was duplicated" do
      stub_post "http://test.curdbee.com/estimates/31/duplicate?api_token=TYMuwW6rM2PQnoWx1ht4", "new_estimate.json"
      result = @estimate.duplicate
      result.estimate_no.should == "EST-NEW" 
    end

    it "should raise a bad request error if duplication fails" do
      stub_post "http://test.curdbee.com/estimates/31/duplicate?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.duplicate
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if estimate doesnt exist" do
      stub_post "http://test.curdbee.com/estimates/31/duplicate?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @estimate.duplicate
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'close' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return true if estimate was closed" do
      stub_post "http://test.curdbee.com/estimates/31/close?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @estimate.close
      result.should be_true 
    end

    it "should raise a bad request error if closing fails" do
      stub_post "http://test.curdbee.com/estimates/31/close?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.close
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if estimate doesnt exist" do
      stub_post "http://test.curdbee.com/estimates/31/close?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @estimate.close
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'reopen' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return true if estimate was reopened" do
      stub_post "http://test.curdbee.com/estimates/31/reopen?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @estimate.reopen
      result.should be_true 
    end

    it "should raise a bad request error if reopening fails" do
      stub_post "http://test.curdbee.com/estimates/31/reopen?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.reopen
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if estimate doesnt exist" do
      stub_post "http://test.curdbee.com/estimates/31/reopen?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @estimate.reopen
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'convert' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return the invoice if estimate was converted to a invoice" do
      stub_post "http://test.curdbee.com/estimates/31/convert?api_token=TYMuwW6rM2PQnoWx1ht4", "new_invoice.json"
      result = @estimate.convert
      result.invoice_no.should == "IN-NEW" 
    end

    it "should raise a bad request error if reopening fails" do
      stub_post "http://test.curdbee.com/estimates/31/convert?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.convert
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if estimate doesnt exist" do
      stub_post "http://test.curdbee.com/estimates/31/convert?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @estimate.convert
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'deliver' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return true if estimate was sent" do
      stub_post "http://test.curdbee.com/deliver/estimate/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @estimate.deliver
      result.should be_true 
    end

    it "should raise a bad request error if sending fails" do
      stub_post "http://test.curdbee.com/deliver/estimate/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @estimate.deliver
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if estimate doesnt exist" do
      stub_post "http://test.curdbee.com/deliver/estimate/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @estimate.deliver
      }.should raise_error(CurdBee::Error::NotFound)
    end
  end

  describe 'permalink' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/estimates/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "estimate.json"
      @estimate = CurdBee::Estimate.show(31)
    end
   
    it "should return the permalink to view a sent invoice" do
      @estimate.permalink.should == "http://test.curdbee.com/est/tx9045ff"
    end

    it "should return nothing for draft invoices" do
      @new_estimate = CurdBee::Estimate.new()
      @new_estimate.permalink.should == ""
    end
  end

end
