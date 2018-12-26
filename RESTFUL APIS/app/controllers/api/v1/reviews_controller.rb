class Api::V1::ReviewsController < ApplicationController
  
  before_action :authenticate_user!

  def index
    if params[:category_id]
      @reviews = paginate Review.where(:category_id => params[:category_id]).order_by_date , per_page: number_per_page      
    else
      @reviews = paginate Review.order_by_date , per_page: number_per_page
    end
    
    render json: @reviews , root: "data" , status: :ok , 
    scope: {'base_url': base_url  , 'current_user': current_user} ,
    meta: {
      status: true, 
      links: pagination_links(@reviews)
    } 
  end

  def create
    @review = Review.new(review_params)
    
    if @review.save
      review_count(1)
      render json: [@review] , root: "data" , status: :created , 
      scope: {'base_url': base_url  , 'current_user': current_user} ,
      meta: {
        status: true
      } 
    else
      render json:{data: @review.errors , meta: {status: false} }  , status: :unprocessable_entity
    end
    
  end

  def show
    @review = Review.where(:id => params[:id])
      render json: [@review] , root: "data" , status: :ok , 
      scope: {'base_url': base_url  , 'current_user': current_user} ,
      meta: {
        status: true
      }       
  end

  def destroy
    review = Review.where(:id => params[:id] , :user_id => current_user.id).first 
    if review && review.destroy
      review_count(2)
      render json:{data: [{message: "review deleted successfully...!" }] , meta: {status: true} }  , status: :ok           
    else
      render json:{data: [{message: "review cannot delete...!" }] , meta: {status: false} }  , status: :ok           
    end
  end

  def my_reviews
    @reviews = paginate Review.where(:user_id => current_user.id) , per_page: number_per_page
    render json: @reviews , root: "data" , status: :ok , 
    scope: {'base_url': base_url  , 'current_user': current_user} ,
    meta: {
      status: true, 
      links: pagination_links(@reviews)
    }       
  end

  private

  def review_params
    params.require(:review).permit(:category_id , :title , :content , :image).merge(user_id: current_user.id)
  end

  def review_count(type)
    user = User.where(:id => current_user.id).first
    if type == 1
      user.count_reviews += 1      
    else
      user.count_reviews -= 1
    end    
    user.save
  end
end
