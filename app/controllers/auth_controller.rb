class AuthController < ApplicationController

  def callback
    auth_hash = request.env['rack.auth']
    # raise auth_hash.inspect
    @mo_poser = MoPoser.setup_poser(auth_hash.symbolize_keys)
    session[:current_poser] = @mo_poser.id
    redirect_to mo_poser_path(@mo_poser.id)
  end

  def failure
    
  end
end

