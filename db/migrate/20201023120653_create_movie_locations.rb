class CreateMovieLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :movie_locations do |t|
      t.integer :movie_id
      t.integer :location_id

      t.timestamps
    end
  end
end
