# encoding: utf-8

class SpacesController < ApplicationController
  def index
    @user=User.find(params[:user_id])
    @spaces = @user.spaces.all
    if params[:user_id].to_s==session[:user_id].to_s
      @isowner=true 
      @h1='我的愿望空间'
    else
      @h1=@user.name+' 的愿望空间'
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wishlists }
    end
  end
  
  def show
    @space=Space.find(params[:id])
    @user=@space.user
    @isowner=true if @user.id==session[:user_id]
    @h1=@user.name+' 的空间 '+@space.name
    @wishes=@space.wishes.all
    flash[:id]=@space.id
    @comments=@space.comments.all
    @comments_counter=@space.comments_counter
    @privacy=@space.privacy
    @is_allowed=isallowed?
  end
  
  def new
    @space=Space.new
  end
  
  def edit
    @space = Space.find(params[:id])
    @privacy=@space.privacy
    unless owner?(@space) #hack#
      redirect_to user_spaces_url(@space.user.id)
    end
  end
  
  def update
    @space = Space.find(params[:id])
    if !owner?(@space) #try to edit others wishlist #hack#
      redirect_to user_spaces_url(@space.user.id) 
    elsif @space.update_attributes(params[:space])
      flash[:success]='修改成功'
      redirect_to user_spaces_url(@space.user.id)
    elsif
      render :action => "edit"
    end
  end
  
  def create
    user=User.find(session[:user_id])
    @space=user.spaces.new(params[:space])
    if @space.save
      flash[:success]='成功创建空间'
      redirect_to user_spaces_url(session[:user_id])
    else
      render :new
    end
  end
  
  def destroy
    @space = Space.find(params[:id])
    if !owner?(@space) #hack#
      redirect_to user_spaces_url(@space.user.id)
    else
      @space.destroy
      flash[:success]='成功删除'
      redirect_to user_spaces_url(session[:user_id])
      end
  end
  
  def comment
    if request.post?
      flash[:error]='失败，请重试' and redirect_to :back and return unless (flash[:id]||isallowed?)
      @space=Space.find(flash[:id])
      @comment=@space.comments.new(:content=>params[:comment])
      @comment.user_id=session[:user_id]
      @comment.user_name=session[:user_name]
      @comment.save
      redirect_to space_url(@space)
    end
    
    if request.delete?
      redirect_to :back,:error=>'sdf' and return unless flash[:id]
      @space=Space.find(flash[:id])
      @comment=@space.comments.find(params[:cid])
      redirect_to space_url(@space) and return unless @space.user_id==session[:user_id] || 
                                                   @comment.user_id==session[:user_id]
      @comment.destroy
      redirect_to space_url(@space)
    end
  
  end
  
  private
  def owner?(space)
    space.user.id==session[:user_id]
  end
  
  def isallowed?
    return true if @isowner
    case @privacy
    when 'onlyme'
      @isowner
    when 'following'
      Follow.following?(session[:user_id],@user.id)
    when 'selected'
      return true if @space.allowed_users.include?(session[:user_name])
    when 'public'
      true    
    end
  end

end
