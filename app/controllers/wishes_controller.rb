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
  
  def show
    @wish=Wish.find(params[:id])
    @isowner=true if @wish.user_id==session[:user_id]
    @h1=@wish.name+' - '+@wish.user.name+'的心愿单'
  end
  
  def destroy
    @wish = Wish.find(params[:id])
    redirect_to(spaces_url(session[:user_id])) and return unless @wish.user_id==session[:user_id]
    @wish.destroy
    redirect_to(space_url(@wish.space))
  end
  
  
end
