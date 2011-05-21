#encoding:utf-8
class RepliesController < ApplicationController
  def create
    begin
      @topic=Topic.find(params[:topic])
    rescue
      render_404
      return
    end
    @reply=@topic.replies.new(params[:reply])
    @reply.user_id=session[:user_id]
    if @reply.save
      flash[:success]='成功'      
    else
      flash[:error]='添加失败，请稍后再试。您刚刚添加的内容是：'+params[:reply][:content]
    end
    redirect_to topic_url(@topic)
  end
  
  def edit
    @topic=Topic.find(params[:topic_id])
    @reply=@topic.replies.find(params[:id])
    render_404 and return unless @reply.user_id==session[:user_id]
  end
  
  def update
    begin
      @topic=Topic.find(params[:topic])
    rescue
      render_404
      rreturn
    end
    @reply=@topic.replies.find(params[:id])    
    render_404 and return unless @reply.user_id==session[:user_id]
    if @reply.update_attributes(params[:reply])
      flash[:success]='修改成功'
      redirect_to topic_url(@topic)
    else
      flash[:error]='修改失败，您刚才提交的内容是：'+params[:topic][:content]
    end    
  end
end
