class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :user_id , :null => false
      t.integer :category_id  , :null => false
      t.string :title , :null => false
      t.text :content , :null => true
      t.text :image   , :null => true
      t.integer :love_count , :null => true , :default => 0
      t.integer :disLike_count , :null => true , :default => 0
      t.integer :share_count , :null => true , :default => 0
      t.integer :retweet_count , :null => true , :default => 0
      t.timestamps
    end
    add_index("reviews" , "user_id")
    add_index("reviews" , "category_id")
  end
end
