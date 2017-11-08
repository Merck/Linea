json.array!(@share_activities) do |share_activity|
  json.extract! share_activity, :id, :dataset_id, :user_id, :comment
  json.url share_activity_url(share_activity, format: :json)
end
