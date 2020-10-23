class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :movie_id
      t.integer :user_id
      t.integer :stars
      t.text :description

      t.timestamps
    end
  end
end
