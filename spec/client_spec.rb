require 'spec_helper'

describe CurdBee::Client do

  describe 'list' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end

    it "should return a list of clients" do
      stub_get "http://test.curdbee.com/clients.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=20", "clients.json"
      result = CurdBee::Client.list
      result.first.name.should == "Awesome Inc." 
    end

    it "should take limit as an option" do
      stub_get "http://test.curdbee.com/clients.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=1", "clients.json"
      result = CurdBee::Client.list(:limit => 1)
      result.length.should == 1 
    end

    it "should take page as an option" do
      stub_get "http://test.curdbee.com/clients.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=2&per_page=1", "clients.json"
      result = CurdBee::Client.list(:limit => 1, :page => 2)
      result.length.should == 1 
    end
  end

  describe 'show' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      #@client = CurdBee::Client.new
    end
   
    it "should return the matching client" do
      stub_get "http://test.curdbee.com/clients/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "client.json"
      result = CurdBee::Client.show(31)
      result.name.should == "Awesome Inc." 
    end

    it "should raise an error if nothing found" do
      stub_get "http://test.curdbee.com/clients/32.json?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        CurdBee::Client.show(32)
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'create' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the created client" do
      stub_post "http://test.curdbee.com/clients?api_token=TYMuwW6rM2PQnoWx1ht4", "new_client.json"
      @client = CurdBee::Client.new(
                                      :name => "RickRoll Inc.",
                                      :email => "rickroll@example.com",
                                      :currency_id => 150
                                   )
      result = @client.create
      @client.id.should == 34 
    end

    it "should raise an error if creation fails" do
      stub_post "http://test.curdbee.com/clients?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @client = CurdBee::Client.new()
        @client.create
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'update' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/clients/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "client.json"
      @client = CurdBee::Client.show(31)
    end
   
    it "should return the updated client" do
      stub_put "http://test.curdbee.com/clients/31?api_token=TYMuwW6rM2PQnoWx1ht4", "new_client.json"
      @client.name = "RickRoll Inc."
      @client.email = "rickroll@example.com"

      result = @client.update
      result.should be_true
    end

    it "should raise an error if update fails" do
      stub_put "http://test.curdbee.com/clients/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @client.name = ""
        @client.update
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'delete' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/clients/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "client.json"
      @client = CurdBee::Client.show(31)
    end
   
    it "should return true if client was deleted" do
      stub_delete "http://test.curdbee.com/clients/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @client.delete
      result.should == true 
    end

    it "should raise a bad request error if deletion fails" do
      stub_delete "http://test.curdbee.com/clients/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @client.delete
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if client doesnt exist" do
      stub_delete "http://test.curdbee.com/clients/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @client.delete
      }.should raise_error(CurdBee::Error::NotFound)
    end


  end

end
