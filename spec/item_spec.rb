require 'spec_helper'

describe CurdBee::Item do

  describe 'list' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end

    it "should return a list of items" do
      stub_get "http://test.curdbee.com/items.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=20", "items.json"
      result = CurdBee::Item.list
      result.first.name.should == "My Item" 
    end

    it "should take limit as an option" do
      stub_get "http://test.curdbee.com/items.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=1", "items.json"
      result = CurdBee::Item.list(:limit => 1)
      result.length.should == 1 
    end

    it "should take page as an option" do
      stub_get "http://test.curdbee.com/items.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=2&per_page=1", "items.json"
      result = CurdBee::Item.list(:limit => 1, :page => 2)
      result.length.should == 1 
    end
  end

  describe 'show' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the matching item" do
      stub_get "http://test.curdbee.com/items/25.json?api_token=TYMuwW6rM2PQnoWx1ht4", "item.json"
      result = CurdBee::Item.show(25)
      result.name.should == "My Item" 
    end

    it "should raise an error if nothing found" do
      stub_get "http://test.curdbee.com/items/27.json?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        CurdBee::Item.show(27)
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'create' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the created item" do
      stub_post "http://test.curdbee.com/items?api_token=TYMuwW6rM2PQnoWx1ht4", "new_item.json"
      @item = CurdBee::Item.new(:name => "My New Item")
      result = @item.create
      @item.id.should == 28 
    end

    it "should raise an error if creation fails" do
      stub_post "http://test.curdbee.com/items?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @item = CurdBee::Item.new()
        @item.create
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'update' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/items/25.json?api_token=TYMuwW6rM2PQnoWx1ht4", "item.json"
      @item = CurdBee::Item.show(25)
    end
   
    it "should return the updated item" do
      stub_put "http://test.curdbee.com/items/25?api_token=TYMuwW6rM2PQnoWx1ht4", "new_item.json"
      @item.name = "My New Item"
      result = @item.update

      result.should be_true 
    end

    it "should raise an error if update fails" do
      stub_put "http://test.curdbee.com/items/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @item.name = ""
        @item.update
      }.should raise_error(CurdBee::Error::BadRequest)
    end


  end

  describe 'delete' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/items/25.json?api_token=TYMuwW6rM2PQnoWx1ht4", "item.json"
      @item = CurdBee::Item.show(25)
    end
   
    it "should return true if item was deleted" do
      stub_delete "http://test.curdbee.com/items/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @item.delete
      result.should == true 
    end

    it "should raise a bad request error if deletion fails" do
      stub_delete "http://test.curdbee.com/items/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @item.delete
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if item doesnt exist" do
      stub_delete "http://test.curdbee.com/items/25?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @item.delete
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

end
