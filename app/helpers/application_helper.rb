module ApplicationHelper
  # Examples:
  #   authenticated_request('characters/101/asssets?datasource=tranquility', params = {'page' => 1})
  def authenticated_request(path, params)
    response = Faraday.get("https://esi.evetech.net/latest/" + path, params,
                       {
                         'Content-type': 'application/json',
                         'Authorization': "Bearer #{session[:access_token]}"
                       })
  end
  def authenticated_post_request(path, body)
    response = Faraday.post("https://esi.evetech.net/latest/" + path, body,
                      {
                         'Content-type': 'application/json',
                         'Authorization': "Bearer #{session[:access_token]}"
                      })
  end
end
