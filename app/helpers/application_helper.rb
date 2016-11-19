module ApplicationHelper
  
  def get_title(page_title)
    base = "- 玉衡的站点"
    if page_title.empty?
      "Blog #{base}"
    else
      "#{page_title} #{base}"
    end
  end
  
  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      no_intra_emphasis: true, 
      fenced_code_blocks: true,   
      disable_indented_code_blocks: true)
    return markdown.render(text).html_safe
  end
end
