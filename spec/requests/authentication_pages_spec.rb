require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  before { visit signin_path }
  
  describe "sign in page" do
    it { should have_title(full_title("Sign in")) }
    it { should have_link("Sign in", href: signin_path) }
    it { should_not have_link("Users", href: users_path) }
    it { should_not have_link("Profile") }
    it { should_not have_link("Settings") }
    it { should_not have_link("Sign out", href: signout_path) }
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
    it { should have_link("Users", href: users_path) }
    it { should have_link("Profile", href: user_path(user)) }
    it { should have_link("Settings", href: edit_user_path(user)) }
    it { should have_link("Sign out", href: signout_path) }
    it { should_not have_link("Sign in", href: signin_path) }
    
    describe "no need to show User#new" do
      before { visit signup_path }
      it { should_not have_title("Sign up") }
    end
    
    describe "need auto redirect to profile visit sign_in" do
      before { visit signin_path }
      it { should_not have_title("Sign in") }
      it { should have_title(full_title(user.nickname)) }
    end
    
    describe "no need to post User#create action" do
      let(:params) do
        { user: { username: "sampleusernew@qq.com", nickname: "Sample User", password: "foobar", password_confirmation: "foobar" } }
      end
      before do
        sign_in user, no_capybara: true
        
      end
      it { expect{ post users_path, params }.not_to change(User, :count) }
    end
    
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
      
      describe "and normal sign in again should show profile" do
        before do
          click_link "Sign out"
          visit signin_path
          fill_in "Email", with: user.username
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        
        it { should have_title(full_title(user.nickname)) }
      end
    end
    
    describe "visiting the user index" do
      before { visit users_path }
      it { should have_title("Sign in") }
    end
    
    describe "visit article index" do
      before { visit articles_path }
      it { should have_content "All articles" }
    end
    
    describe "visit show article" do
      let(:article) { FactoryGirl.create(:article) }
      before { visit article_path(article) }
      it { should have_content article.content }
    end
    
    describe "visit new article" do
      before { get new_article_path }
      it { expect(response).to redirect_to signin_path }
    end
    
    describe "submitting to the create article" do
      before { post articles_path }
      it { expect(response).to redirect_to signin_path }
    end
    
    describe "visit edit article" do
      before { get edit_article_path(FactoryGirl.create(:article)) }
      it { expect(response).to redirect_to signin_path }
    end
    
    describe "submitting to update article" do
      before { patch article_path(FactoryGirl.create(:article)) }
      it { expect(response).to redirect_to signin_path }
    end
    
    describe "submitting to the destory article" do
      before { delete article_path(FactoryGirl.create(:article)) }
      it { expect(response).to redirect_to signin_path }
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
  
  describe "as non admin user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:non_admin) { FactoryGirl.create(:user) }
    
    before { sign_in non_admin, no_capybara: true }
    
    describe "submitting a DELETE request to the Users#destroy action" do
      before { delete user_path(user) }
      it { expect(response).to redirect_to(root_path) }
    end
  end
  
  describe "as admin user" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin, no_capybara: true
    end
    
    it "should not delete himself" do
      expect { delete user_path(admin) }.not_to change(User, :count)
    end
    
    describe "should jump to home when delete himself" do
      before { delete user_path(admin) }
      it { expect(response).to redirect_to(root_path) }
    end
  end
end
