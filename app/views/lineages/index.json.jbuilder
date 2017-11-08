json.array!(@lineages) do |lineage|
  json.extract! lineage, :id, :dataset_id, :parent_dataset_id, :operation, :comment
  json.url lineage_url(lineage, format: :json)
end
