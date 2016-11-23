require 'spec_helper'

describe "User Pages" do
  subject { page }
  
  describe "sign up page" do
    before { visit signup_path }
    it { should have_content("Sign up") }
    it { should have_title(full_title("Sign up")) }
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    
    before { visit user_path(user) }
    
    it { should have_content(user.nickname) }
    it { should have_title(full_title(user.nickname)) }
  end
  
  describe "signup" do
    before { visit signup_path }
    
    let(:submit) { "Create my accout" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name", with: "Chris Chen"
        fill_in "Email", with: "chrischen@qq.com"
        fill_in "Password", with: "123456"
        fill_in "Confirmation", with: "123456"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(username: 'chrischen@qq.com') }
        
        it { should have_link("Sign out")}
        it { should have_title(user.nickname) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end
end
