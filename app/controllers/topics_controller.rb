#encoding:utf-8

class TopicsController < ApplicationController

  def index
    @topics=Topic.all.desc(:last_replied_at)
  end
  
  def show
    @topic=Topic.find(params[:id])
    @author=@topic.user
    @reply=Reply.new
    @replies=@topic.replies.all
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
  
  def edit
    @topic=Topic.find(params[:id])
    render_404 and return unless @topic.user_id==session[:user_id]
  end
  
  def update
    @topic=Topic.find(params[:id])
    render_404 and return unless @topic.user_id==session[:user_id]
    if @topic.update_attributes(params[:topic])
      flash[:success]='修改成功'
      redirect_to topic_url(@topic)
    else
      render :new
    end    
  end
  
  def destory
  
  end

  
end
