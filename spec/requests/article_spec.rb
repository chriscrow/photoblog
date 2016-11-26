require 'spec_helper'

describe "article" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @article = Article.new(content:"Lorem ipsum", user_id: user.id)
  end
  
  subject { @article }
  
  it { should respond_to :content }
  it { should respond_to :user_id }
end