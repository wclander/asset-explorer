class AssetsController < ApplicationController
  def view
    if !session[:logged_in]
      redirect_to root_path and return
    end

    total_pages = 1
    current_page = 1
    @all_assets = []

    while total_pages >= current_page do
      response = helpers.authenticated_request("characters/#{character_id}/assets/?datasource=tranquility&page=#{current_page}", {})

      if response.status == 401
        session[:logged_in] = false
        redirect_to root_path and return
      elsif response.status != 200
        return render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
      end

      @all_assets.push(*JSON.parse(response.body))
      total_pages = response.headers["X-Pages"].to_i
      current_page += 1
    end

    all_ids = Set[]

    @all_assets.each do |asset|
      all_ids.add(asset["type_id"].to_i)
    end

    all_names = *JSON.parse(helpers.authenticated_post_request("universe/names?datasource=tranquility", all_ids.to_a.to_json).body)

    names_dict = Hash.new {""}
    all_names.each do |name|
      names_dict[name["id"].to_i] = name["name"]
    end

    @all_assets.each do |asset|
      asset["name"] = names_dict[asset["type_id"].to_i]
    end
  end

  def total

  end

  def search
  end
end
