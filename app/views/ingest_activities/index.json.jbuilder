json.array!(@ingest_activities) do |ingest_activity|
  json.extract! ingest_activity, :id, :dataset_id, :user_id, :comment
  json.url ingest_activity_url(ingest_activity, format: :json)
end
