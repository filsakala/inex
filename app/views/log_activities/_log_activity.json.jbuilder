json.extract! log_activity, :id, :created_at, :updated_at
json.url log_activity_url(log_activity, format: :json)