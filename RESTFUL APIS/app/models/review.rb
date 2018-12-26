class Review < ApplicationRecord
    belongs_to :user
    belongs_to :category
    has_many   :review_reactions

    mount_uploader :image , ImageUploader

    scope :order_by_date , lambda { order(:created_at => :ASC)}
    # Ex:- scope :active, lambda {where(:active => true)}

    validates :user_id, presence: true
    validates :category_id, presence: true
    validates :title, presence: true    
end
