class Movie < ApplicationRecord
    has_many :movie_actors
    has_many :movie_locations
    has_one :director
    has_many :locations
    has_many :reviews
end
