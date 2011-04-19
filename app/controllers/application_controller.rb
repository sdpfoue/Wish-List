#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale,:ifLoggedin,:setsession
 
  
  def set_locale
    #I18n.locale = extract_locale_from_user_config || extract_locale_from_accept_language_header || I18n.default_locale
	I18n.locale = 'zh-CN'
  end
  
  
  def set_page_title(value)
    @page_title = value+' - '
  end
  
  def logged?
    !!session[user_id]
  end
  
  def set_remember_cookie
    return if !current_logined?

    current_user.remember_me
    cookies[:auth_token] = {
      :value   => current_user.remember_token,
      :expires => current_user.remember_token_expires_at }
  end
  
  def current_logined?
    !!current_user
  end
  
  def current_user
    @current_user ||= login_form_session || login_from_cookies || false if @current_user != false
    @current_user
  end
  
  def login_form_session
    User.find session[:user_id] if session[:user_id]
  rescue
    nil
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user ? user.id : nil
  end
  
  protected
    def ifLoggedin
      unless session[:user_id]
        flash[:url]=request.url
        redirect_to login_url, :notice => "请先登陆"
      end
    end
   def setsession
     @logged=true if session[:user_id]
     @user_name=session[:user_name]
   end
  
end
