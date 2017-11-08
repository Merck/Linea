json.array!(@tags) do |tag|
  json.extract! tag, :id, :name, :created_by
  json.url tag_url(tag, format: :json)
end
