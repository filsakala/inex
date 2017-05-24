json.array!(@volunteers) do |volunteer|
  json.extract! volunteer, :id
  json.url volunteer_url(volunteer, format: :json)
end
