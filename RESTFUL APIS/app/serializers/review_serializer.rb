class ReviewSerializer < ActiveModel::Serializer
  attributes :id , 
             :title ,
             :content ,
             :image , 
             :react_type,
             :love_count, 
             :disLike_count, 
             :share_count, 
             :retweet_count, 
             :created_at 

  has_one :category  
  has_one :user

  def image
    return scope[:base_url]+object.image.url
  end

  def react_type
    current_user = scope[:current_user]
    react_record = ReviewReaction.where(:user_id => current_user.id , :review_id => object.id).first
    if react_record
      react_record.react_type
    else
      0
    end
  end

end
