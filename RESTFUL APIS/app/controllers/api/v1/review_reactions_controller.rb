class Api::V1::ReviewReactionsController < ApplicationController
    
    before_action :authenticate_user!
#****************************************************************#
    def top_trusted
        user_ids = Review.distinct.order(:love_count => :DESC).limit(3).pluck(:user_id)
        @users    = User.where(:id => user_ids)
        render json: @users , root: "data" , status: :ok , 
        scope: {'base_url': base_url  , 'current_user': current_user} ,
        meta: {
          status: true,
          user_ids: user_ids
        } 
    end
#****************************************************************#
    def reacted_reviews_by_me
        react_type = params[:react_type]
        if [1 , 2].include? react_type.to_i 
            review_ids = ReviewReaction.distinct.where(:react_type => react_type , :user_id => current_user.id).pluck(:review_id)
            @reviews = paginate Review.where(:id => review_ids) , per_page: number_per_page
            render json: @reviews , root: "data" , status: :ok , 
            scope: {'base_url': base_url  , 'current_user': current_user} ,
            meta: {
              status: true, 
              links: pagination_links(@reviews),
              review_ids: review_ids
            }  
        else
          render json:{data: [{message: "react_type must be 1 or 2" }] , meta: {status: false} }  , status: :ok           
        end
    end
#****************************************************************#
    def make_reaction
        @review_reaction = ReviewReaction.where(:user_id => current_user.id , :review_id => params[:review_id]).first
        if !@review_reaction
            @review_reaction = ReviewReaction.new(review_reaction_params)
        else
            @review_reaction.react_type = params[:react_type]
        end
        if @review_reaction.save
            handel_review_love_dis_like_counts(@review_reaction.review_id , params[:react_type])
            handel_user_love_dis_like_counts(params[:react_type])
            render json: [@review_reaction] , root: "data" , status: :created , 
            scope: {'base_url': base_url  , 'current_user': current_user} ,
            meta: {
            status: true
            } 
        else
            render json:{data: @review_reaction.errors , meta: {status: false} }  , status: :unprocessable_entity
        end
    end
#****************************************************************#
    def share_review 
        @review = Review.where(:id => params[:review_id]).first
        if @review && params[:type] 
            if [1 , 2].include? params[:type].to_i 
                if params[:type].to_i == 1 #1 refer to share count
                    @review.share_count += 1
                else
                    @review.retweet_count += 1
                end
                @review.save
                render json: [@review] , root: "data" , status: :ok, 
                scope: {'base_url': base_url  , 'current_user': current_user} ,
                meta: {
                status: true
                } 
            else
                render json:{data: {message: "type must be (1 or 2) "} , meta: {status: false} }  , status: :unprocessable_entity
            end
        else
            render json:{data: {message: "review_id must exist and type must be (1 or 2) "} , meta: {status: false} }  , status: :unprocessable_entity
        end
    end
#****************************************************************#
    private

    def review_reaction_params
        params.permit(:review_id , :react_type).merge(user_id: current_user.id)
    end

    def handel_review_love_dis_like_counts(review_id , react_type)
        review_reactions = ReviewReaction.select("review_id , react_type , count(react_type) as count").group(:review_id , :react_type).having(:review_id => review_id)
        react_types = []
        if !review_reactions.empty?  
            review_reactions.each do |review_reaction|
                if review_reaction.react_type == 1
                    review_reaction.review.love_count = review_reaction.count
                elsif review_reaction.react_type == 2 
                    review_reaction.review.disLike_count = review_reaction.count 
                end 
                review_reaction.review.save
                react_types << review_reaction.react_type
            end

            if !react_types.include? 1
                review_reactions.first.review.love_count = 0
            elsif !react_types.include? 2 
                review_reactions.first.review.disLike_count = 0          
            end
            review_reactions.first.review.save
            review_reactions
        end 
    end

    def handel_user_love_dis_like_counts(react_type)
        review_reactions = ReviewReaction.select("user_id , react_type , count(react_type) as count").group(:user_id , :react_type).having(:user_id => current_user.id)
        react_types = []
        if !review_reactions.empty?  
            review_reactions.each do |review_reaction|
                if review_reaction.react_type == 1
                    review_reaction.user.count_love = review_reaction.count
                elsif review_reaction.react_type == 2 
                    review_reaction.user.count_disLike = review_reaction.count 
                end 
                review_reaction.user.save
                react_types << review_reaction.react_type
            end

            if !react_types.include? 1
                review_reactions.first.user.count_love = 0
            elsif !react_types.include? 2 
                review_reactions.first.user.count_disLike = 0          
            end
            review_reactions.first.user.save
            review_reactions
        end 
    end
#****************************************************************#
end
