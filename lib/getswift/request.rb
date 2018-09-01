class Request
  class << self
    def where(resource_path, query = {}, type="get")
      response, status = if type == "post"
                            post_json(resource_path, query)
                         elsif type == "get"
                            get_json(resource_path, query)
                         end
      status == 200 ? response : errors(response)
    end

    def get(id)
      response, status = get_json(id)
      status == 200 ? response : errors(response)
    end

    def errors(response)
      error = { errors: { status: response["status"], message: response["message"] } }
      response.merge(error)
    end

    def get_json(root_path, query = {})
      query_string = query.map{|k,v| "#{k}=#{v}"}.join("&")
      path = query.empty?? root_path : "#{root_path}?#{query_string}"
      response = api.get(path)
      [JSON.parse(response.body), response.status]
    end

    def post_json(root_path, query = {})
      response = api.post do |req|
        req.url root_path
        req.headers['Content-Type'] = 'application/json'
        req.body = (query.to_json)
      end
      [JSON.parse(response.body), response.status]
    end

    def api
      Connection.api
    end
  end
end