json.array!(@columns) do |column|
  json.extract! column, :id, :dataset_id, :name, :description, :data_type, :business_name
  json.url column_url(column, format: :json)
end
