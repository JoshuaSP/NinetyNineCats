json.array!(@cats) do |cat|
  json.extract! cat, :id, :name, :birth_date, :color, :sex, :description
  json.url cat_url(cat, format: :json)
end
