class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true
  validates :title, presence: true

  serialize :images,Array

  before_save :process_content
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  end

  private
  
  def process_content
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      no_intra_emphasis: true, 
      fenced_code_blocks: true,   
      disable_indented_code_blocks: true)
    html = markdown.render(self.content).html_safe
    matches = html.scan(/<img\s+.*src=\"([^\"]*)\"\s+.*>/i)
    # for matches is a two-demi array
    matches.each do |match|
      self.images.push match[0]
    end
  end
end
