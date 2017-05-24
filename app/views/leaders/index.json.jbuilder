json.array!(@leaders) do |leader|
  json.extract! leader, :id
  json.url leader_url(leader, format: :json)
end
