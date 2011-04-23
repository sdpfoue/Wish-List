#encoding:utf-8

class FollowController < ApplicationController
  def fo
    @user=User.find(params[:id])
    if @user.id.to_s==session[:user_id].to_s
      flash[:error]='不能关注自己'
      redirect_to :back and return if :back
      redirect_to index_url and return
    end
    f=Follow.new(following_id:session[:user_id],user_id:@user.id)
    if f.save
      flash[:success]='关注成功'
    else
      flash[:error]='关注失败，请稍候重试'
    end
    redirect_back
  end
  
  def unfo
  
  end
end
