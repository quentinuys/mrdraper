class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.string :year
      t.integer :director_id

      t.timestamps
    end
  end
end
