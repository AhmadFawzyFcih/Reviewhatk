class Category < ApplicationRecord
    scope :order_by_name , lambda { order(:name => :ASC)}
end
