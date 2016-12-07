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
    let!(:a1) { FactoryGirl.create(:article, user: user, content: "Foo") }
    let!(:a2) { FactoryGirl.create(:article, user: user, content: "Bar") }
    
    before { visit user_path(user) }
    
    it { should have_content(user.nickname) }
    it { should have_title(full_title(user.nickname)) }
    
    describe "articles" do
      it { should have_content(a1.content) }
      it { should have_content(a2.content) }
      it { should have_content(user.articles.count) }
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      describe "following a user" do
        before { visit user_path(other_user) }
        
        it "should increment the followed user count" do
          expect { click_button "Follow" }.to change(user.followed_users, :count).by(1)
        end
        
        it "should increment the other user's followers count" do
          expect { click_button "Follow" }.to change(other_user.followers, :count).by(1)
        end
        
        describe "toggle the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end
      
      describe "unfollow a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        
        it "should decrement the followed user count" do
          expect { click_button "Unfollow" }.to change(user.followed_users, :count).by(-1)
        end
        
        it "should decrement the other user's followers count" do
          expect { click_button "Unfollow" }.to change(other_user.followers, :count).by(-1)
        end
        
        describe "toggle the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
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
        fill_in "Confirm Password", with: "123456"
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
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: "http://gravatar.com/emails") }
    end
    
    describe "with invalid information" do
      before { click_button "Save changes" }
      
      it { should have_content("error") }
    end
    
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "newemail@qq.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      
      it { should have_title(new_name) }
      it { should have_selector("div.alert.alert-success", text: "Profile updated") }
      it { should have_link("Sign out", href: signout_path) }
      it { expect(user.reload.username).to eq new_email }
      it { expect(user.reload.nickname).to eq new_name }
    end
    
    describe "forbidden attribute" do
      let(:params) do
        { user: { admin:true, password: user.password, password_confirmation: user.password } }
      end
      
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      it { expect(user.reload).not_to be_admin }
    end
  end
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end
    
    it { should have_title("All users") }
    it { should have_content("All users") }
    
    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }
      
      it { should have_selector('div.pagination') }
      
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector("li", text: user.nickname)
        end
      end
    end
    
    describe "delete link" do
      it { should_not have_content("delete") }
      
      describe "as admin user sign in" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          click_link "Sign out"
          sign_in admin
          visit users_path
        end
        
        it { should have_link("delete", href: user_path(User.first)) }
        
        it "should be able to delete another user" do
          expect do
            click_link("delete", match: :first)
          end.to change(User, :count).by(-1)
        end
        
        it { should_not have_link("delete", href: user_path(admin)) }
      end
    end
  end
  
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }
    
    describe "followed user" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      
      it { should have_title("Following") }
      it { should have_selector("h3", text: "Following") }
      it { should have_link(other_user.nickname, href: user_path(other_user)) }
    end
    
    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      
      it { should have_title("Followers") }
      it { should have_selector("h3", text: "Followers") }
      it { should have_link(user.nickname, href: user_path(user)) }
    end
  end
end
