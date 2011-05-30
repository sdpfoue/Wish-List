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
  
  def logedin?
    !!session[:user_id]
  end
  
  def current_user
    @current_user ||= login_form_session 
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
  
  def render_404
    render_optional_error_file(404)
  end
  
  def render_optional_error_file(status_code)
    status = status_code.to_s
    if ["404", "422", "500"].include?(status)
      render :template => "/errors/#{status}.html.erb", :status => status, :layout => "application"
    else
      render :template => "/errors/unknown.html.erb", :status => status, :layout => "application"
    end
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
   
  def redirect_back
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to index_url 
    end
  end
  
end
