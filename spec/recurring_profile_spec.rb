require 'spec_helper'

describe CurdBee::RecurringProfile do

  describe 'list' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end

    it "should return a list of recurring_profiles" do
      stub_get "http://test.curdbee.com/recurring_profiles.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=20", "recurring_profiles.json"
      result = CurdBee::RecurringProfile.list
      result.first.profile_name.should == "RP-Test" 
    end

    it "should take limit as an option" do
      stub_get "http://test.curdbee.com/recurring_profiles.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=1&per_page=1", "recurring_profiles.json"
      result = CurdBee::RecurringProfile.list(:limit => 1)
      result.length.should == 1 
    end

    it "should take page as an option" do
      stub_get "http://test.curdbee.com/recurring_profiles.json?api_token=TYMuwW6rM2PQnoWx1ht4&page=2&per_page=1", "recurring_profiles.json"
      result = CurdBee::RecurringProfile.list(:limit => 1, :page => 2)
      result.length.should == 1 
    end
  end

  describe 'show' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the matching recurring_profile" do
      stub_get "http://test.curdbee.com/recurring_profiles/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "recurring_profile.json"
      result = CurdBee::RecurringProfile.show(31)
      result.profile_name.should == "RP-Test" 
    end

    it "should raise an error if nothing found" do
      stub_get "http://test.curdbee.com/recurring_profiles/32.json?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        CurdBee::RecurringProfile.show(32)
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

  describe 'create' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
    end
   
    it "should return the created recurring_profile" do
      stub_post "http://test.curdbee.com/recurring_profiles?api_token=TYMuwW6rM2PQnoWx1ht4", "new_recurring_profile.json"
      recurring_profile_info = {:start_date => Date.today, :invoice_no => "RP-NEW", :client_id => @client.id,
                                :frequency => "1", :occurences => "0", :profile_name => "test profile",
                                :line_items_attributes => [{:name_and_description => "Sample Item", :quantity => 1, :price => 25.00, :unit => "hour"}]
                               }
      @recurring_profile = CurdBee::RecurringProfile.new(recurring_profile_info)
      result = @recurring_profile.create
      @recurring_profile.id.should == 31 
    end

    it "should raise an error if creation fails" do
      stub_post "http://test.curdbee.com/recurring_profiles?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @recurring_profile = CurdBee::RecurringProfile.new({})
        @recurring_profile.create
      }.should raise_error(CurdBee::Error::BadRequest)
    end

  end

  describe 'update' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/recurring_profiles/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "recurring_profile.json"
      @recurring_profile = CurdBee::RecurringProfile.show(31)
    end
   
    it "should return the updated recurring_profile" do
      stub_put "http://test.curdbee.com/recurring_profiles/31?api_token=TYMuwW6rM2PQnoWx1ht4", "new_recurring_profile.json"
      @recurring_profile.profile_name = "RP-New"
      @recurring_profile.date = Date.today

      result = @recurring_profile.update
      result.should be_true 
    end

    it "should raise an error if update fails" do
      stub_put "http://test.curdbee.com/recurring_profiles/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @recurring_profile.profile_name = ""
        @recurring_profile.update
      }.should raise_error(CurdBee::Error::BadRequest)
    end

  end

  describe 'delete' do

    before do
      CurdBee::Config.api_key = "TYMuwW6rM2PQnoWx1ht4"
      CurdBee::Config.subdomain = "test"
      stub_get "http://test.curdbee.com/recurring_profiles/31.json?api_token=TYMuwW6rM2PQnoWx1ht4", "recurring_profile.json"
      @recurring_profile = CurdBee::RecurringProfile.show(31)
    end
   
    it "should return true if recurring_profile was deleted" do
      stub_delete "http://test.curdbee.com/recurring_profiles/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 200
      result = @recurring_profile.delete
      result.should be_true 
    end

    it "should raise a bad request error if deletion fails" do
      stub_delete "http://test.curdbee.com/recurring_profiles/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 422
      lambda{
        @recurring_profile.delete
      }.should raise_error(CurdBee::Error::BadRequest)
    end

    it "should raise a not found error if recurring_profile doesnt exist" do
      stub_delete "http://test.curdbee.com/recurring_profiles/31?api_token=TYMuwW6rM2PQnoWx1ht4", "", 404
      lambda{
        @recurring_profile.delete
      }.should raise_error(CurdBee::Error::NotFound)
    end

  end

end
