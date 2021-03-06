#encoding:utf-8

class WishesController < ApplicationController
  def new
    redirect_to(user_spaces_url(session[:user_id])) and return unless Space.find(params[:s])[:user_id]==session[:user_id]
    @space=Space.find(params[:s])
    @wish=Wish.new
    flash[:s]=params[:s]
  end
  
  
  def create
    redirect_to(spaces_url) and return unless Space.find(flash[:s])[:user_id]==session[:user_id]
    @wish = Wish.new(params[:wish])
    @wish.user_id=session[:user_id]
    @wish.space_id=flash[:s]
    if @wish.save
      flash[:new]=true
      redirect_to(@wish, :notice => '成功添加愿望')
    else
      render :action => "new"
    end

  end
  
  def edit
    @wish = Wish.find(params[:id])
    @space=@wish.space
    redirect_to(user_spaces_url(session[:user_id])) and return unless @wish[:user_id]==session[:user_id]
  end
  
  def update
    @wish = Wish.find(params[:id])
    render_404 and return unless @wish[:user_id]==session[:user_id]

    if @wish.update_attributes(params[:wish])
      redirect_to(@wish, :notice => '修改成功') 
    else
      render :action => "edit" 
    end

  end
  
  def show
    @wish=Wish.find(params[:id])
    @user=@wish.user
    flash[:id]=@wish.id
    @isowner=true if @wish.user_id==session[:user_id]
    @h1=@wish.name+' - '+@wish.user.name+'的心愿单'
    @comments=@wish.comments.all
    @comments_counter=@wish.comments_counter
    @privacy=@wish.space.get_privacy
    @isallowed=@wish.space.isallowed?(session[:user_id],session[:user_name])
  end
  
  def destroy
    @wish = Wish.find(params[:id])
    redirect_to(user_spaces_url(session[:user_id])) and return unless @wish.user_id==session[:user_id]
    @wish.destroy
    redirect_to(space_url(@wish.space))
  end
  
  def comment
    if request.post?
      @wish=Wish.find(flash[:id])
      @space=@wish.space
      flash[:error]='失败，请重试' and redirect_to :back and return unless (flash[:id]||@space.isallowed?(session[:user_id],session[:user_name]))
      @comment=@wish.comments.new(:content=>params[:comment])
      @comment.user_id=session[:user_id]
      @comment.user_name=session[:user_name]
      @comment.save
      redirect_to wish_url(@wish)
    end
    
    if request.delete?
      @wish=Wish.find(flash[:id])
      @comment=@wish.comments.find(params[:cid])
      redirect_to wish_url(@wish) and return unless @wish.user_id==session[:user_id]||@comment.user_id==session[:user_id]
      @comment.destroy
      redirect_to wish_url(@wish)
    end
  end
  
  def tag
    @wishes=Wish.where
  end
  
end
