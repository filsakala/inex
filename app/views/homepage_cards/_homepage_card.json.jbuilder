json.extract! homepage_card, :id, :title, :url, :priority, :created_at, :updated_at
json.url homepage_card_url(homepage_card, format: :json)