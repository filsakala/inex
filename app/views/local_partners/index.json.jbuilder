json.array!(@local_partners) do |local_partner|
  json.extract! local_partner, :id
  json.url local_partner_url(local_partner, format: :json)
end
