class IndexController < ApplicationController
  def index
    @timeline=Timeline::Base.all(sort:[[:created_at, :desc]])
  end

end
