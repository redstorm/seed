class PagesController < ApplicationController
  
  before_filter :login_required
  before_filter :pages_menu, :except => [:create, :update, :destroy]

  def new
    @page = Page.new(:menu_type => "primary")
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      flash[:notice] = 'Page was successfully created'
      redirect_to resource_path(@page) 
    else
      @pages = Page.pages_for_dropdown(params[:id])
      pages_menu
      render :action => "new" 
    end
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated'
      redirect_to resource_path(@page) 
    else
      @pages = Page.pages_for_dropdown(params[:id])
      pages_menu
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    redirect_to home_url 
  end
  
  private
  
  def resource_path(page)
    eval ("#{page.kind}_path(#{page.id})")
  end
end
