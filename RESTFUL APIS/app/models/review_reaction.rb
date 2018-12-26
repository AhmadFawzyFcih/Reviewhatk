class ReviewReaction < ApplicationRecord

    belongs_to :review
    belongs_to :user

    validates :review_id, presence: true
    validates :react_type, presence: true , :inclusion=> { :in => [0,1,2] }
    
end
