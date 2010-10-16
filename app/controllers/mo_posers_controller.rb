class MoPosersController < ApplicationController

  def show
    @mo_poser = MoPoser.find(params[:id]) #session[:current_poser]
  end


end
