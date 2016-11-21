require 'spec_helper'

describe "Users" do
  
  # subject { page }
  #
  # describe "GET /users" do
  #   before{ visit "/users"}
  #
  #   it { should have_content("Listing Users") }
  #   it { should have_title("All Users") }
  # end
  
  before do
    @user = User.new(username: "user@gmail.com", password: "somepassword")
  end
  
  subject { @user }
  
  it { should respond_to(:username) }
  it { should respond_to(:password) }
  
  it { should be_valid }
  
  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before { @user.password = " " }
    it { should_not be_valid }
  end
  
  describe "when username is too long" do
    before { @user.username = "a"*51 }
    it { should_not be_valid }
  end
  describe "when password is too long" do
    before { @user.password = "a"*51 }
    it { should_not be_valid }
  end
  
  describe "when username format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.username = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when username format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.username = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.username = @user.username.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "when save username should be donwcase" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    
    it "should save as downcase" do
      @user.username = mixed_case_email
      @user.save
      expect(@user.reload.username).to eq mixed_case_email.downcase
    end
  end
end
