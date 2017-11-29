json.extract! reply, :id, :title, :body, :user_id, :reply_id, :created_at, :updated_at
json.url reply_url(reply, format: :json)
