module UsersHelper
  
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.username.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt:user.nickname, class:"gravatar")
  end
end
