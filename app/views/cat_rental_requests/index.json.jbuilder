json.array!(@cat_rental_requests) do |rental_request|
  json.extract! rental_request, :id, :cat_id, :start_date, :end_date, :status
  json.url cat_rental_request_url(rental_request, format: :json)
end