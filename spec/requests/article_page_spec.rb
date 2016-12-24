require 'rails_helper'

describe "Article Page" do
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "article creation" do
    before { visit new_article_path }
    
    describe "with invalid information" do
      it "should not create article" do
        expect { click_button "Post" }.not_to change(Article, :count)
      end
      
      describe "error msg" do
        before { click_button "Post" }
        it { should have_content("error") }
      end
    end
    
    describe "with valid infomation" do
      before do
        fill_in "article_content", with: "#I'am title\nand content"
        fill_in "article_title", with: "#I'am title"
      end
      
      it "should create an article" do
        expect { click_button "Post" }.to change(Article, :count)
      end
    end
  end
  
  describe "article destruction" do
    before { FactoryGirl.create(:article, user:user) }
    
    describe "as correct_user" do
      before { visit root_path }
      
      it "should delete a article" do
        expect{ click_link "delete" }.to change(Article, :count).by(-1)
      end
    end
  end
end