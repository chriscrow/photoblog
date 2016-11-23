require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  before { visit signin_path }
  
  describe "sign in page" do
    it { should have_content("Sign in") }
    it { should have_title(full_title("Sign in")) }
  end
  
  describe "with invalid information" do
    before { click_button "Sign in" }
    
    it { should have_title(full_title("Sign in")) }
    it { should have_selector("div.alert.alert-danger", text: "Invalid") }
    
    describe "after visit another page" do
      before { click_link "Sign up now"}
      it { should_not have_selector("div.alert.alert-danger") }
    end
  end
  
  describe "with valid infomation" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      fill_in "Email", with: user.username.upcase
      fill_in "Password", with: user.password
      click_button "Sign in"
    end
    
    it { should have_title(full_title(user.nickname)) }
    it { should have_link("Profile", href: user_path(user)) }
    it { should have_link("Sign out", href: signout_path) }
    it { should_not have_link("Sign in", href: signin_path) }
    
    describe "followed by sign out" do
      before { click_link "Sign out" }
      
      it { should have_link("Sign in", href: signin_path) }
      it { should_not have_link("Sign out") }
    end
  end
end
