json.array!(@update_activities) do |update_activity|
  json.extract! update_activity, :id, :user_id, :dataset_id, :comment
  json.url update_activity_url(update_activity, format: :json)
end
