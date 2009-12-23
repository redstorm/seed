class ArticlesController < ApplicationController
  
  caches_action :index,
                :unless => :logged_in?, 
                :cache_path => Proc.new { |c| c.params[:page_id] } 
                
  cache_sweeper :article_sweeper, :only => [:create, :update, :destroy]
  
  before_filter :login_required, :except => [:index, :show, :archive]
  before_filter :get_page, :only => [:index, :new, :edit, :show, :archive]
  before_filter :check_view_rights, :only => [:index]
  before_filter :check_edit_rights, :only => [:new, :edit]
  
  def index
    @articles = @page.articles.paginate(:page => params[:page], :per_page => @page.paginate)
    if @page.id == 1
      render :template => "homepage/index"
    end
  end

  def new
    @article = Article.new(:page_id => params[:page_id])
    @images = []
  end

  def edit
    @article = Article.find(params[:id])
    @images = @article.images
  end

  def create
    @article = Article.new(params[:article])

    if @article.save
      flash[:notice] = "#{@article.article_type.capitalize} was successfully created"
      redirect_to resource_index_page(@article)
    else
      @images = @article.images
      get_page
      render :action => "new" 
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = "#{@article.article_type.capitalize} was successfully updated"
      redirect_to resource_index_page(@article)
    else
      @images = @article.images
      get_page
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to resource_index_page(@article)
  end
  
  private 
  
  def resource_index_page(resource)
    if resource.article_type == "post"
      page_posts_path(resource.page_id) 
    elsif resource.article_type == "news"
      page_newsitems_path(resource.page_id) 
    else
      page_articles_path(resource.page_id) 
    end
  end
  
end
