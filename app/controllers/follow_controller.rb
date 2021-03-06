#encoding:utf-8

class FollowController < ApplicationController
  #respond_to :js
 
  
  def fo
    @user=User.find(params[:id])
    if @user.id.to_s==session[:user_id].to_s
      flash[:error]='不能关注自己'
      redirect_to :back and return if :back
      redirect_to user_url([:user_id]) and return
    end
    @user_id=@user.id
    
    f=Follow.new(following_id:@user.id,user_id:session[:user_id])
    if f.save
      flash[:success]='关注成功'
      @follower_counter=@user.follower_counter+1
    else
      flash[:error]='关注失败，请稍候重试'
      redirect_back
    end
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
  end
  
  def unfo
    Follow.unfo(session[:user_id],params[:id])
    @user_id=params[:id]
    @user=User.find(params[:id])
    @follower_counter=@user.follower_counter
    respond_to do |format|
      format.js {render 'fo.js.erb'}
    end
  end
  
  def fo_tag
    @user=User.find(session[:user_id])
    @tag=params[:tag]
    @user.add_interested_tags(@tag)
    respond_to do |format|
      format.html {redirect_to(tag_topics_url(:tag=>@tag))}
      format.js
    end
    
  end
  def unfo_tag
   @tag=params[:tag]
    current_user.remove_interested_tags(@tag)
    respond_to do |format|
      format.html {redirect_to tag_topics_url(:tag=>@destroy_tag)}
      format.js
    end
  end
end
