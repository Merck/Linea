json.array!(@algorithms) do |algorithm|
  json.extract! algorithm, :id, :name, :path
  json.url algorithm_url(algorithm, format: :json)
end
