require 'spec_helper'

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
      before { fill_in "article_content", with: "#I'am title\nand content" }
      
      it "should create an article" do
        expect { click_button "Post" }.to change(Article, :count)
      end
    end
  end
end