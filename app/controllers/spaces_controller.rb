# encoding: utf-8

class SpacesController < ApplicationController
  def index
    @user=User.find(params[:user_id])
    @spaces = @user.spaces.all
    if params[:user_id].to_s==session[:user_id].to_s
      @isowner=true 
      @h1='我的心愿单'
    else
      @h1=@user.name+' 的心愿单'
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
  end
  
  def new
    @space=Space.new
  end
  
  def edit
    @space = Space.find(params[:id])
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
  
  private
  def owner?(space)
    space.user.id==session[:user_id]
  end

end
