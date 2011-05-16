#encoding:utf-8

class TopicsController < ApplicationController

  def index
    @topics=Topic.all
  end
  
  def show
    @topic=Topic.find(params[:id])
    @author=@topic.user
    @reply=Reply.new
  end 
  
  def new
    @topic=Topic.new
  end
  
  def create
    @topic=Topic.new(params[:topic])
    @topic.user_id=session[:user_id]
    if @topic.save
      flash[:success]='成功发起话题'
      redirect_to topics_url
    else
      render :new
    end
  end
  
  def update
  
  end
  
  def destory
  
  end

  
end
