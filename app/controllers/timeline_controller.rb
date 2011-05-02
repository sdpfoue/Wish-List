class TimelineController < ApplicationController
  def del
    t=Timeline::Base.find(params[:id])
    redirect_to :back and return unless t.user.id==session[:user_id]
    @id=t.id
    t.destroy
    #redirect_to :back
    respond_to do |format|
      format.js
    end
  end
end
