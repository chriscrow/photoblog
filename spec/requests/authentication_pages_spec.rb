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
    before { sign_in(user) }
    
    it { should have_title(full_title(user.nickname)) }
    it { should have_link("Profile", href: user_path(user)) }
    it { should have_link("Settings", href: edit_user_path(user)) }
    it { should have_link("Sign out", href: signout_path) }
    it { should_not have_link("Sign in", href: signin_path) }
    
    describe "followed by sign out" do
      before { click_link "Sign out" }
      
      it { should have_link("Sign in", href: signin_path) }
      it { should_not have_link("Sign out") }
    end
  end
  
  describe "for non-signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    
    describe "visit edit page" do
      before { visit edit_user_path(user) }
      it { should have_title("Sign in") }
      it { should have_selector("div.alert.alert-notice", text: "sign in") }
    end
    
    describe "submiting to update action" do
      before { patch user_path(user) }
      it { expect(response).to redirect_to(signin_path) }
    end
    
    describe "visit protected page after sign in" do
      before do
        visit edit_user_path(user)
        fill_in "Email", with: user.username
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it { should have_title("Edit user") }
    end
  end
  
  describe "as wrong user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, username: "wrong@qq.com") }
    
    describe "visit User#edit page" do
      before do
        sign_in user
        visit edit_user_path(wrong_user)
      end
      
      it { should_not have_title(full_title("Edit user")) }
    end
    
    describe "submit a patch request to User#edit action" do
      before do
        sign_in user, no_capybara: true
        patch user_path(wrong_user)
      end
      it { expect(response).to redirect_to(root_path) }
    end
  end
end
