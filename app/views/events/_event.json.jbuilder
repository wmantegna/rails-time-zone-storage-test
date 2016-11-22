json.extract! event, :id, :name, :start, :time_zone, :created_at, :updated_at
json.url event_url(event, format: :json)