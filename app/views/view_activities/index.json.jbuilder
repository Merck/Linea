json.array!(@view_activities) do |view_activity|
  json.extract! view_activity, :id, :dataset_id, :user_id
  json.url view_activity_url(view_activity, format: :json)
end
