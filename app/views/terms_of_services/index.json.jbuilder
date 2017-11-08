json.array!(@terms_of_services) do |terms_of_service|
  json.extract! terms_of_service, :id, :name, :description
  json.url terms_of_service_url(terms_of_service, format: :json)
end
