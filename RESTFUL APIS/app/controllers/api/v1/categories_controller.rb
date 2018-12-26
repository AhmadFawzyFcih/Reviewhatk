class Api::V1::CategoriesController < ApplicationController
  def index
    @categories = paginate Category.order_by_name , per_page: number_per_page
    render json: @categories , root: "data" , status: :ok , meta: {
      status: true,
      links: pagination_links(@categories)
    } 
  end
end
