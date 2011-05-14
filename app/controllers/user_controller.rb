#encoding: utf-8

class UserController < ApplicationController
  skip_before_filter :ifLoggedin,:only=>[:reg,:create]
  
  def reg
    @user=User.new
    set_page_title I18n.t 'user.reg.signup'
  end

  def create
    @user = User.new params[:user]
    @user.reg_ip=request.remote_ip
    if @user.save
      session[:user_id] = @user._id
      session[:user_name]=@user.name
      set_remember_cookie if params[:user][:remember_me] == "1"
      flash[:success]= '注册成功，感谢您的注册，祝您的愿望早日成真'
      redirect_to index_url
    else
      set_page_title I18n.t 'use.reg.signup'
      render :reg
    end
  end

  def show
	  @user=User.find(params[:id])
	  @user_id=@user.id
	  @followers=@user.get_followers
	  @following=@user.get_following
	  @h1=@user.name
  end
  
  def auth_callback
    auth = request.env["omniauth.auth"]
    Authorization.create_from_hash(auth,User.find(session[:user_id]))
    redirect_back
    
  end

end
