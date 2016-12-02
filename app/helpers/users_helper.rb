module UsersHelper
  
  def gravatar_for(user, options={size:50})
    gravatar_id = Digest::MD5::hexdigest(user.username.downcase)
    size = options[:size]
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt:user.nickname, class:"gravatar")
  end
end
