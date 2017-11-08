json.array!(@subject_areas) do |subject_area|
  json.extract! subject_area, :id, :name, :description
  json.url subject_area_url(subject_area, format: :json)
end
