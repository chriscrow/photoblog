require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit "/users"
      page.status_code.should == 200
      expect(page).to have_content("Listing Users")
    end
    
    it "title mast have All Users" do
      visit "/users"
      expect(page).to have_title("All Users")
    end
  end
end
