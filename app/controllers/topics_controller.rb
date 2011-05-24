#encoding:utf-8

class TopicsController < ApplicationController
  respond_to :html,:rss, :only => [:index, :tagged]
  def index
    @current='index'
    @topics=Topic.all.desc(:last_replied_at)
    set_page_title('茶馆 ')
    @wishes=Wish.get_tagged_wishes('',session[:user_id],session[:user_name])
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
  
  def tag
    @tag = params[:tag]
    @current='tag'
    @h1=@tag
    @wishes=Wish.get_tagged_wishes(@tag,session[:user_id],session[:user_name])
    set_page_title(@tag)
    if params[:format] == 'rss'
        @topics = Topic.where(:tags => @tag).desc(:created_at).paginate :per_page => 20, :page => params[:page]
    else
        @topics = Topic.where(:tags => @tag).desc(:last_replied_at).paginate :per_page => 20, :page => params[:page]
    end
    
    respond_with(@topics) do |format|
      format.html { render :index }
      format.rss  do
        @channel_link = tagged_topics_url(:tag => @tag)
        render :topics, :layout => false
      end
      format.js { render :index, :layout => false }
    end    
    
    
  end
  
  def destory
  
  end

  
end
