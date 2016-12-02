class ArticlesController < ApplicationController
  before_action :sign_in_user, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:destroy]
  
  def index
    @articles = Article.all
  end

  def show
  end

  def new
    @article = Article.new
  end
  
  def edit
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
        redirect_to @article
    else
        render 'new'
    end
  end
  def update
    if @article.update(article_params)
        redirect_to @article
    else
        render 'edit'
    end
  end
  
  def destroy
    @article.destroy
    redirect_to articles_path
  end
  
  private
    def set_article
      @article = Article.find(params[:id])
    end
  
    def correct_user
      arti = current_user.articles.find_by_id(@article.id)
      redirect_to root_path if arti == nil
    end
  
    def article_params
        params.require(:article).permit(:content)
    end
end
