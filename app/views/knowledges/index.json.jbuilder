json.array!(@knowledges) do |knowledge|
  json.extract! knowledge, :id, :title, :text
  json.url knowledge_url(knowledge, format: :json)
end
