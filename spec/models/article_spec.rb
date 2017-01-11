require 'rails_helper'

describe "article" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @article = user.articles.build(content:"Lorem ipsum", title:"title")
  end
  
  subject { @article }
  
  it { should respond_to :content }
  it { should respond_to :title }
  it { should respond_to :user_id }
  it { should respond_to :user }
  its(:user) { should eq user }
  it { should respond_to :images }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @article.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank content" do
    before { @article.content = "" }
    it { should_not be_valid }
  end
  
  describe "with blank title" do
    before { @article.title = "" }
    it { should_not be_valid }
  end

  describe "with content inlcude image" do
    before do
      @article.title = "some title"
      @article.content = "some content\n[img]:http://somesite.com/foo2.jpg\n" +
        "![](http://somesite.com/foo1.jpg)\n![alt][img]"
      @article.save
    end
    
    its(:images) { should include("http://somesite.com/foo1.jpg", "http://somesite.com/foo2.jpg") }
  end
end