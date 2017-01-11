module ArticlesHelper
  def markdown(text, options={remove_img:0})
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      no_intra_emphasis: true, 
      fenced_code_blocks: true,   
      disable_indented_code_blocks: true)
    html = markdown.render(text)
    if options[:remove_img] > 0
      options[:remove_img].times do
        html.sub!(/<img\s+.*src=\"([^\"]*)\"\s+.*>/i, "")
      end
    end
    return html.html_safe
  end
  
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end
  private
    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
    end
end
