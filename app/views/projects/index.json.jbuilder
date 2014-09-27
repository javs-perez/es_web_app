json.array!(@projects) do |project|
  json.extract! project, :id, :status
  json.url project_url(project, format: :json)
end
