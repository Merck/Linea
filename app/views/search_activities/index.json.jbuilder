json.array!(@search_activities) do |search_activity|
  json.extract! search_activity, :id, :user_id, :search_terms
  json.url search_activity_url(search_activity, format: :json)
end
