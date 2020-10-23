class Actor < ApplicationRecord
    belongs_to :movie
    has_many :movie_locations
end
