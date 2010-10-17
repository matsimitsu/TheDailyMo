class MoPosersController < ApplicationController

  before_filter :find_user, :only => [:show, :update]

  def index
    
  end

  def show
    render :layout => false if request.xhr?
  end

  # make an new image with the posted values
  # params[:rotation] Rotation od overlay
  # params[:position] Position of overlay
  # params[:size]     Size of overlay
  # params[:img_src]  Source of overlay
  def update
    require 'open-uri' # needs monkeypatch for following redirects for facebook (see initializers)
    profile_picture_url = @mo_poser.connector.profile_picture_url
    logger.info profile_picture_url
    buffer        = open(profile_picture_url).read
    profile_image = Magick::Image.from_blob(buffer).first
    snor_image    = Magick::Image.read(Rails.root.join('public','images', params[:img_src]).to_s).first

    # scale the profile image to a know size
    profile_image.resize!(200.0 / profile_image.columns)
    center_of_old_snor = {:x => snor_image.columns / 2, :y => snor_image.rows / 2}

    # Make the new pixels transparent
    snor_image.background_color = 'none'

    # Scale and rotate the snor
    snor_image.resize!(params[:size].to_f/100) # TODO: Sanity check on size
    snor_image.rotate!(params[:rotation].to_f) # TODO: Sanitize input?

    center_of_new_snor = {:x => snor_image.columns/2, :y => snor_image.rows/2}

    # Get the new upper left corner of rotated and scaled snor
    x_position = params[:position][:x].to_i # + (center_of_old_snor[:x] - center_of_new_snor[:x])
    y_position = params[:position][:y].to_i # + (center_of_old_snor[:y] - center_of_new_snor[:y])

    # Compose
    result = profile_image.composite(snor_image, x_position, y_position, Magick::OverCompositeOp)

    # Save the snorriefied picture
    # photo = @mo_poser.photos.new
    StringIO.open(result.to_blob) do |data|
      # raise data.methods.sort.inspect
      data.original_filename = "photo.jpg"
      data.content_type      = "image/jpeg"
      @mo_poser.photo        = data
    end
    @mo_poser.save!

    # send_data result.to_blob, :type => result.mime_type, :disposition => 'inline'

    # go to the 'upload to profile' page
    redirect_to confirm_mo_poser_path
  end



private

  def find_user
    if session[:current_poser].present?
      @mo_poser = MoPoser.find(session[:current_poser])
    else
      flash[:error] = "Eerst authoriseren met Hyves/Twitter/etc"
      redirect_to root_path and return
    end
  end

end
