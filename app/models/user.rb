class User < ActiveRecord::Base
  before_save { self.username = username.downcase }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence:true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :nickname, presence:true, length: { maximum: 50 }
  
  has_secure_password
  
  validates :password, presence:true, length: { minimum: 6, maximum:20}
end
