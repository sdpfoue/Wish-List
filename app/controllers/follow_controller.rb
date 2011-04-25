#encoding:utf-8

class FollowController < ApplicationController
  def fo
    @user=User.find(params[:id])
    if @user.id.to_s==session[:user_id].to_s
      flash[:error]='不能关注自己'
      redirect_to :back and return if :back
      redirect_to user_url([:user_id]) and return
    end
    f=Follow.new(following_id:@user.id,user_id:session[:user_id])
    if f.save
      #flash[:success]='关注成功'
    else
      flash[:error]='关注失败，请稍候重试'
      redirect_back
    end
    respond_to do |format|
      format.js
    end
  end
  
  def unfo
    Follow.unfo(session[:user_id],params[:id])
    respond_to do |format|
      format.js
    end
  end
end
