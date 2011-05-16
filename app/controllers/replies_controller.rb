#encoding:utf-8
class RepliesController < ApplicationController
  def create
    begin
      @topic=Topic.find(params[:topic])
    rescue
      render_404
      return
    end
    @topic.replies.new(params[:reply])
    if @topic.save
      flash[:success]='成功'      
    else
      flash[:error]='添加失败，请稍后再试'
    end
    redirect_to topic_url(@topic)
  end
end
