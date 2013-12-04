class Api::V3::ApiRequestsController < Api::V3::BaseController

  load_and_authorize_resource

  def index
    if params[:key] == "local"
      collection = ApiRequest.where("api_key = ?", APP_CONFIG['api_key'])
    elsif params[:key] == "external"
      collection = ApiRequest.where("api_key != ?", APP_CONFIG['api_key'])
    elsif params[:key]
      collection = ApiRequest.where("api_key = ?", params[:key])
    else
      collection = ApiRequest.where("ids LIKE ?", "Api::%")
    end

    @api_requests = collection.order("created_at DESC").limit(10000)
  end
end