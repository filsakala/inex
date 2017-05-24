class TinymceAssetsController < ApplicationController
  def create
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed

    @image = Mercury::Image.new(image: params[:file])
    @image.save

    render json: {
      image: {
        url: @image.url
      }
    }, content_type: "text/html"
  end
end
