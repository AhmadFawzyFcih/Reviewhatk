class CreateReviewReactions < ActiveRecord::Migration[5.1]
  def change
    create_table :review_reactions do |t|
      t.integer :user_id
      t.integer :review_id
      t.integer :react_type
      t.timestamps
    end
    add_index("review_reactions", "user_id")
    add_index("review_reactions", "review_id")
  end
end
