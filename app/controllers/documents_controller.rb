# encoding: utf-8
class DocumentsController < InexMemberController
  before_action :set_google_drive, except: [:callback, :google_signout]
  before_action :set_drive_folder, only: [:index, :new_file, :edit_file]
  include DocumentsHelper
  require 'google/apis/drive_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'

  rescue_from Google::Apis::ClientError, with: :authorize

  CREDENTIALS_PATH = Rails.root.join('public', '.credentials', 'drive-ruby-quickstart.yaml')
  SCOPE            = [Google::Apis::DriveV3::AUTH_DRIVE_FILE, Google::Apis::DriveV3::AUTH_DRIVE_METADATA_READONLY]

  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id   = Google::Auth::ClientId.from_file(Rails.root.join('app', 'assets', 'javascripts', 'drive_secret2.json'))
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer  = Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, callback_documents_url(host: "#{request.protocol}#{request.host_with_port}"))
    user_id     = 'default'
    credentials = authorizer.get_credentials(user_id, request)
    if credentials.nil?
      redirect_to authorizer.get_authorization_url(login_hint: user_id, request: request)
    end
    credentials
  rescue Signet::AuthorizationError # Refresh token

  end

  def callback
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect_to target_url, success: t(:google_login_was_successful)
  end

  def google_signout
    FileUtils.remove(CREDENTIALS_PATH)
    redirect_to documents_path, success: t(:you_were_successfully_logged_out_from_google)
  end

  def new_file
    file_metadata = {
      name:      "New Spreadsheet #{DateTime.now.strftime('%d.%m.%Y %H:%m')}",
      mime_type: "application/vnd.google-apps.spreadsheet",
      parents:   [@folders.first.id]
    }
    @service.create_file(file_metadata, fields: 'id')
    redirect_to documents_path, success: "#{t :file} #{define_notice('m', :create)}"
  end

  def delete_file
    @service.delete_file(params[:file_id])
    redirect_to documents_path, success: "File was successfully deleted from Google Drive."
  rescue Google::Apis::ClientError
    redirect_to documents_path, error: "Error: #{$!.message}"
  end

  def duplicate_file
    @service.copy_file(params[:file_id], Google::Apis::DriveV3::File.new)
    redirect_to documents_path, success: "File was successfully duplicated on Google Drive."
  rescue Google::Apis::ClientError
    redirect_to documents_path, error: "Error: #{$!.message}"
  end

  # GET /documents
  # GET /documents.json
  def index
    @service.list_files(q:      "mimeType='application/vnd.google-apps.folder' and name = 'INEX Webpage'",
                        fields: 'nextPageToken, files(id, name)')
    if @folders.size == 0 # Create file folder & JSON folder
      file_metadata = {
        name:      'INEX Webpage',
        mime_type: 'application/vnd.google-apps.folder'
      }
      folder        = @service.create_file(file_metadata, fields: 'id')
      file_metadata = {
        name:      'json',
        mime_type: 'application/vnd.google-apps.folder',
        parents:   [folder.id]
      }
      @service.create_file(file_metadata, fields: 'id')
      @drive_files = []
    else
      @drive_files = []
      @folders.each do |folder|
        @drive_files += @service.list_files(q:      "'#{folder.id}' in parents and mimeType != 'application/vnd.google-apps.folder'",
                                            fields: 'nextPageToken, files(id, name, mimeType, webViewLink)').files

        json_folder = @service.list_files(q:      "'#{folder.id}' in parents and mimeType = 'application/vnd.google-apps.folder' and name='json'",
                                          fields: 'nextPageToken, files(id, name, mimeType, webViewLink)').files
        if json_folder.size == 0
          file_metadata = {
            name:      'json',
            mime_type: 'application/vnd.google-apps.folder',
            parents:   [folder.id]
          }
          @service.create_file(file_metadata, fields: 'id')
        end
      end
    end
    if @folders.size > 1
      flash[:warning] = "Existujú aspoň dva priečinky 'INEX Webpage' v tvojom
      Google Drive. Tentokrát spájam ich súbory dohromady, vyrieš to, aby bolo
      jasné, kam ukladať nové súbory."
    end
  end

  def edit_file
    @file = @service.get_file(params[:file_id], fields: "id, name, mimeType, webViewLink")
    csv = @service.export_file(@file.id, "text/csv") # File saved to string as csv!
    @csv = CSV.parse(csv) if !csv.blank?
  rescue Google::Apis::ClientError
    redirect_to documents_path, error: "Error: #{$!.message}"
  end

  def edit_stats
    @file = @service.get_file(params[:file_id], fields: "id, name, mimeType, webViewLink")
    @row, @col  = params[:row], params[:col]
    if @row.blank? || @col.blank?
      redirect_to documents_path, flash: { error: "Error: Musíš vyplniť riadok a stĺpec na vyplnenie štatistiky." }
    end
    # Now try to get JSON stats
    @json_stats_files = @service.list_files(q:      "name='#{@file.id}' and mimeType='application/vnd.google-apps.document'",
                                            fields: 'nextPageToken, files(id, name, mimeType, webViewLink)').files
    if @json_stats_files.any?
      json_file = @service.export_file(@json_stats_files.first.id, "text/plain")
      if !json_file.blank?
        begin
          json = JSON.parse(json_file.encode('UTF-8', :invalid => :replace, :undef => :replace, replace: "")) # avoid invalid characters in string
          if !json["#{@row}"].blank? && !json["#{@row}"]["#{@col}"].blank?
            @json_stats = json["#{@row}"]["#{@col}"]
          end
        rescue JSON::ParserError # do nothing
          flash[:error] = "Nepodarilo sa načítať predchádzajúce nastavenie štatistiky. #{$!.message}"
        end
      end
    end
    csv = @service.export_file(@file.id, "text/csv") # File saved to string as csv!
    @csv = CSV.parse(csv) if !csv.blank?
  rescue Google::Apis::ClientError
    redirect_to documents_path, error: "Error: #{$!.message}"
  end

  def update_stats
    @file             = @service.get_file(params[:file_id], fields: "id, mimeType")
    rcount            = result_stats(params)
    @col              = params[:col]
    @row              = params[:row]

    # prepare JSON string
    @json_stats_files = @service.list_files(q:      "name='#{@file.id}' and mimeType='application/vnd.google-apps.document'",
                                            fields: 'nextPageToken, files(id, name, mimeType, webViewLink)').files
    # JSON STATS START
    @my_json_stats    = {
      "stats_type":     "#{params[:stats_type]}",
      "years":          "#{params[:years]}",
      "event_type_ids": "#{params[:event_type_ids]}",
      "event_ids":      "#{params[:event_ids]}",
      "do_uniq":        "#{params[:do_uniq]}",
      "people":         "#{params[:people]}",
      "education_ids":  "#{params[:education_ids]}",
      "sex":            "#{params[:sex]}"
    }
    (0..20).each do |i|
      if !params["age_from_#{i}"].blank? && !params["age_to_#{i}"].blank?
        @my_json_stats["age_from_#{i}"] = params["age_from_#{i}"]
        @my_json_stats["age_to_#{i}"]   = params["age_to_#{i}"]
      end
    end
    # JSON STATS END
    if @json_stats_files.any?
      json_file = @service.export_file(@json_stats_files.first.id, "text/plain")
      if !json_file.blank?
        begin
          @json_stats = JSON.parse(json_file)
          if !@json_stats["#{@row}"].blank? && !@json_stats["#{@row}"]["#{@col}"].blank?
            @json_stats["#{@row}"]["#{@col}"] = @my_json_stats
          elsif !@json_stats["#{@row}"].blank?
            @json_stats["#{@row}"]["#{@col}"] = @my_json_stats
          else
            @json_stats["#{@row}"]            = {}
            @json_stats["#{@row}"]["#{@col}"] = @my_json_stats
          end
        rescue JSON::ParserError # do nothing
          @json_stats                       = {}
          @json_stats["#{@row}"]            = {}
          @json_stats["#{@row}"]["#{@col}"] = @my_json_stats
        end
      else
        @json_stats                       = {}
        @json_stats["#{@row}"]            = {}
        @json_stats["#{@row}"]["#{@col}"] = @my_json_stats
      end
      # raise "#{@json_stats}"
      @service.update_file(@json_stats_files.first.id, {}, fields: 'id', upload_source: StringIO.new(JSON.generate(@json_stats)), content_type: 'text/plain')
    else # create json file
      json_folder   = @service.list_files(q:      "mimeType = 'application/vnd.google-apps.folder' and name='json'",
                                          fields: 'nextPageToken, files(id, name, mimeType, webViewLink)').files
      file_metadata = {
        name:      "#{@file.id}",
        mime_type: 'application/vnd.google-apps.document',
        parents:   [json_folder.first.id]
      }
      file          = @service.create_file(file_metadata,
                                           fields:        'id',
                                           upload_source: StringIO.new(JSON.generate({ "#{@row}": { "#{@col}": @my_json_stats } })),
                                           content_type:  'text/plain')
    end
    if @file.mime_type == "application/vnd.google-apps.spreadsheet"
      csv                        = @service.export_file(@file.id, "text/csv") # File saved to string as csv!
      @csv                       = CSV.parse(csv) if !csv.blank?
      @csv[@row.to_i][@col.to_i] = "#{rcount}"
      @csv_string                = ""
      @csv.each do |row|
        @csv_string += row.to_csv
      end
      # raise "#{@csv_string}"
      @service.update_file(@file.id, {}, fields: 'id', upload_source: StringIO.new(@csv_string), content_type: 'text/csv')
    end

    redirect_to edit_file_documents_path(file_id: @file.id), success: "Zmeny boli úspešne uložené."
  rescue Google::Apis::ClientError
    redirect_to documents_path, error: "Error: #{$!.message}"
  end

  def update_file
    @file      = @service.get_file(params[:file_id])
    ufile      = Google::Apis::DriveV3::File.new
    ufile.name = "Dokument bez názvu"
    ufile.name = params[:name] if !params[:name].blank?
    if @file.mime_type == "application/vnd.google-apps.spreadsheet"
      csv      = @service.export_file(@file.id, "text/csv") # File saved to string as csv!
      @csv     = CSV.parse(csv) if !csv.blank?
      # change values
      max_size = 100
      # raise "#{@csv}"
      (0...@csv.size).each do |ri|
        (0...@csv[ri].size).each do |ci|
          if params[:csv] && params[:csv][ri.to_s] && !params[:csv][ri.to_s][ci.to_s].blank?
            @csv[ri][ci] = params[:csv][ri.to_s][ci.to_s]
          elsif @csv[ri] && !@csv[ri][ci].blank?
            @csv[ri][ci] = ""
          end
        end
      end
      # raise "#{@csv}"
      @csv_string = ""
      @csv.each do |row|
        @csv_string += row.to_csv
      end
      # raise "#{@csv_string}"
      @service.update_file(@file.id, ufile, fields: 'id', upload_source: StringIO.new(@csv_string), content_type: 'text/csv')
    end
    redirect_to edit_file_documents_path(file_id: @file.id), success: "File was successfully changed."
  rescue Google::Apis::ClientError
    redirect_to edit_file_documents_path(file_id: @file.id), error: "Error: #{$!.message}"
  end

  private
  def set_google_drive
    @service                                 = Google::Apis::DriveV3::DriveService.new
    @service.client_options.application_name = 'INEX Webpage'
    @service.authorization                   = authorize
  end

  def set_drive_folder
    @folders = @service.list_files(q:      "mimeType='application/vnd.google-apps.folder'
                                          and name = 'INEX Webpage'",
                                   fields: 'nextPageToken, files(id, name)').files
  end
end
