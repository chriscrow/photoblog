require 'rails_helper'

describe "Static pages" do
  
  subject { page }
  
  describe "Home page" do
    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:article, user: user, title: "Lorem", content: "Lorem ipsum")
        FactoryGirl.create(:article, user: user, title: "Dolor", content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      
      it "should render user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("h3.title", text:item.title)
          expect(page).to have_selector(".editormd-html-preview", text:item.content)
        end
      end
      
      describe "follower/following count" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end
end