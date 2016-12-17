class WelcomeController < ApplicationController
  def index
    if signed_in?
      @feed_items = current_user.feed.paginate(per_page:10, page: params[:page])
    else
      @feed_items = Article.limit(10).paginate(per_page:10, page: params[:page], total_entries:30)
    end
  end
end
