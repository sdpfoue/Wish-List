class TimelineController < ApplicationController
  def del
    t=Timeline::Base.find(params[:id])
    redirect_to :back and return unless t.user.id==session[:user_id]
    t.destroy
    redirect_to :back
  end
end
