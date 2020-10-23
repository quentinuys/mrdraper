class Location < ApplicationRecord
    belongs_to :country
    has_many :movie_locations
end
