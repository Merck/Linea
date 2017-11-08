json.array!(@review_activities) do |review_activity|
  json.extract! review_activity, :id, :user_id_integer, :dataset_id, :review, :rating
  json.url review_activity_url(review_activity, format: :json)
end
