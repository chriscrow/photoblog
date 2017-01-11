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
        expect{ click_link "Delete" }.to change(Article, :count).by(-1)
      end
    end
  end
  
  describe "article index" do
    before do
      30.times do |n|
        FactoryGirl.create(:article, user:user, title:"title#{n}")
      end
      visit articles_path
    end
    
    it "should list all articles" do
      Article.paginate(per_page: 10, page: 1).each do |article|
        expect(page).to have_selector("h3", text: article.title)
      end
    end
  end

  describe "article showing" do
    before do
      FactoryGirl.create(:article, user:user, content:"![](http://somesite.com/foo.jpg)")
      visit articles_path
      #save_and_open_page
    end

    it { should have_xpath("//img[@src='http://somesite.com/foo.jpg']", count: 1) }
    #it { should have_selector("image", src: "http://somesite.com/foo.jpg", count: 1) }
  end
end