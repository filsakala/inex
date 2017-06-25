# encoding: UTF-8
class RecommendersController < InexMemberController
  before_action :set_google_drive, except: [:callback, :google_signout]
  include DocumentsHelper
  require 'google/apis/youtube_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  layout "page_part"

  rescue_from Google::Apis::ClientError, with: :authorize

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
  APPLICATION_NAME = 'INEX Webpage'
  CLIENT_SECRETS_PATH = Rails.root.join('app', 'assets', 'javascripts', 'drive_secret2.json')
  CREDENTIALS_PATH = Rails.root.join('public', '.credentials', 'drive-ruby-quickstart2.yaml')
  SCOPE = [Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY]

  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, callback_documents_url(host: "#{request.protocol}#{request.host_with_port}"))
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id, request)
    if credentials.nil?
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request)
    end
    credentials
  rescue Signet::AuthorizationError # Refresh token

  end

  def google_signout
    FileUtils.remove(CREDENTIALS_PATH)
    redirect_to edit_recommender_path(params[:id]), success: t(:you_were_successfully_logged_out_from_google)
  end

  def edit
    @recommender = Recommender.find(params[:id])
    playlist_ids = []
    channels = @service.list_channels("snippet,contentDetails,statistics", mine: true)
    channels.items.each do |channel|
      playlist_ids << channel.content_details.try(:related_playlists).try(:uploads)
    end
    next_page_token = ""
    @videos = []
    while next_page_token != nil
      playlist_items = @service.list_playlist_items("snippet", playlist_id: playlist_ids.reject(&:blank?).join(','), max_results: 50, page_token: next_page_token)
      next_page_token = playlist_items.next_page_token
      @videos += playlist_items.items
    end
  end

  # PATCH
  def add
    RecommendationResult.create(recommender_id: params[:id], url: params[:url], thumbnail_url: params[:thumbnail_url], title: params[:title])
    render :nothing => true
  end

  # DELETE
  def remove
    RecommendationResult.find(params[:recommendation_id]).destroy
    render :nothing => true
  end

  private
  def set_google_drive
    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.client_options.application_name = 'INEX Webpage'
    @service.authorization = authorize
  end
end
