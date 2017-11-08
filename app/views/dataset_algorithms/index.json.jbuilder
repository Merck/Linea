json.array!(@dataset_algorithms) do |dataset_algorithm|
  json.extract! dataset_algorithm, :id, :dataset_id, :algorithm_id
  json.url dataset_algorithm_url(dataset_algorithm, format: :json)
end
