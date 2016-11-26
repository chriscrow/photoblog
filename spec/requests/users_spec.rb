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
    @user = User.new(username: "user@gmail.com",
                  nickname: "Sample User",
                  password: "somepassword",
                  password_confirmation: "somepassword")
  end
  
  subject { @user }
  
  it { should respond_to(:username) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:nickname) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "after set admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    
    it { should be_admin }
  end
  
  describe "when username is not present" do
    before { @user.username = " " }
    it { should_not be_valid }
  end
  
  describe "when nickname is not present" do
    before { @user.nickname = " " }
    it { should_not be_valid }
  end
  
  describe "when username is too long" do
    before { @user.username = "a"*51 }
    it { should_not be_valid }
  end
  describe "when nickname is too long" do
    before { @user.nickname = "a"*51 }
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
  
  describe "when password is not present" do
    before do
      @user = User.new(username: "user@gmail.com",
                    nickname: "Sample User",
                    password: " ",
                    password_confirmation: " ")
    end
    
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save}
    let (:found_user) { User.find_by(username: @user.username) }
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
  
    describe "with invalid password" do
      let (:user_for_invalid_password) { found_user.authenticate("invalid")}
      
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end
  describe "with a password that's too long" do
    before { @user.password = @user.password_confirmation = "a" * 21 }
    it { should_not be_valid }
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
