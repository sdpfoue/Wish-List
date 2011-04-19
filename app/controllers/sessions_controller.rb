#encoding:utf-8

class SessionsController < ApplicationController
  skip_filter :ifLoggedin
  
  def new
    flash[:url]=flash[:url] #取得登陆前页面URL并传给create
    redirect_to index_url, :notice=>'您已经成功登陆' if session[:user_id] 
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      session[:user_name]=user.name
      flash[:notice]="欢迎回来"
      if flash[:url] 
        redirect_to flash[:url] 
      else 
        redirect_to index_url
      end
    else
      flash[:url]=flash[:url]
      redirect_to login_url, :alert => "错误的用户名或密码"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :back, :notice => "您已经退出"
  end

end
