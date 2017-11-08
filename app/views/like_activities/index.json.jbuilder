json.array!(@like_activities) do |like_activity|
  json.extract! like_activity, :id, :dataset_id, :user_id
  json.url like_activity_url(like_activity, format: :json)
end
