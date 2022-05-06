class AssetsController < ApplicationController
  def view
    page = 1
    response = Faraday.get("https://esi.evetech.net/latest/characters/#{character_id}/assets/?datasource=tranquility&page=#{page}",
                       { 
#                        'param' => 'foo'
                       },
                       {
                         'Content-type': 'application/json',
                         'Authorization': "Bearer #{session[:access_token]}"
                       })
    @all_assets = JSON.parse(response.body)
  end

  def search
  end
end
