class ApplicationController < ActionController::API
    include ActionController::Serialization
    respond_to :json
    
    def render_resource(resource)
        if resource.errors.empty?
          render json: [resource] , root: "data"  , status: :ok ,  scope: {'base_url': base_url }, meta: {
            status: true
          } 
        else
          validation_error(resource)
        end
    end
    
    def validation_error(resource)
      render json: [resource.errors] , root: "data" , meta: {status: false}  , status: :bad_request
    end

    def base_url
      if request.port
        "#{request.protocol}#{request.host}:#{request.port}"
      else
        "#{request.protocol}#{request.host}"
      end
    end

    private
    
    def number_per_page
        @per_page ||= params[:per_page] || 3
    end

    def pagination_links(object)
        {
          first_page: page_link(1),
          current_page: page_link(object.current_page),
          next_page: page_link(object.next_page),
          prev_page: page_link(object.previous_page),
          last_page: page_link(object.total_pages),
          total_pages: object.total_pages,
          per_page: object.per_page,
          total_count: object.total_entries
        }
    end
    
    def page_link(page)
        if page 
          base_uri = request.url.split("?").first
          "#{base_uri}?#{request.query_parameters.merge(page: page , per_page:number_per_page ).to_param}"
        end
    end 
end
