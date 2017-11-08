json.array!(@dataset_visual_tools) do |dataset_visual_tool|
  json.extract! dataset_visual_tool, :id, :name, :dataset_id
  json.url dataset_visual_tool_url(dataset_visual_tool, format: :json)
end
