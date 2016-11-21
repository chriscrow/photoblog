#include ApplicationHelper

def full_title(page_title)
  base = "- 玉衡的站点"
  if page_title.empty?
    "Blog #{base}"
  else
    "#{page_title} #{base}"
  end
end