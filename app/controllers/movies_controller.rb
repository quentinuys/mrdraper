require 'csv'

class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    if(params[:search])
      @movies = Movie.includes(:reviews, :movie_actor).where('movie_actor.actor_id' => params[:search]).order("reviews.stars desc")
    else
      @movies = Movie.includes(:reviews).order("reviews.stars desc")
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    CSV.foreach(Rails.root.join("public", "movies.csv").to_s, headers: true) do |row|
      import_movie(row.to_h)
    end
    CSV.foreach(Rails.root.join("public", "reviews.csv").to_s, headers: true) do |row|
      import_review(row.to_h)
    end
  end


  private


    def import_movie(row)

      
      country_id = add_country(row["Country"])
      director_id = add_director(row["Director"])
      actor_id = add_actor(row["Actor"])
      location_id = add_location(row["Filming Location"], country_id)
      
      movie_name = row["Movie"]
      description = row["Description"]
      year = row["Year"]
      

      movie_id = Movie.find_or_create_by(name: movie_name, description: description, year: year, director_id: director_id)
      add_movie_actor(movie_id, actor_id)
      add_movie_location(movie_id, location_id)
    end

    def import_review(row)
      stars = row["Stars"]
      description = row["Review"]

      user_id = add_user(row["User"])
      movie_id = Movie.where(:name => row["Movie"]).first.id

      Review.find_or_create_by(movie_id: movie_id, user_id: user_id, description: description, stars: stars)
    end

    def add_country(country_name)
      Country.find_or_create_by(name: country_name).id
    end

    def add_director(director_name)
      name_split = director_name.split(' ', 2)
      Director.find_or_create_by(name: name_split[0], surname: name_split[1]).id
    end

    def add_actor(actor_name)
      name_split = actor_name.split(' ', 2)
      Actor.find_or_create_by(name: name_split[0], surname: name_split[1]).id
    end

    def add_user(user_name)
      name_split = user_name.split(' ', 2)
      User.find_or_create_by(name: name_split[0], surname: name_split[1]).id
    end

    def add_location(location, country_id)
      Location.find_or_create_by(name: location, country_id: country_id[1]).id
    end

    def add_movie_actor(movie_id, actor_id)
      MovieActor.find_or_create_by(movie_id: movie_id, actor_id: actor_id).id
    end

    def add_movie_location(movie_id, location_id)
      MovieLocation.find_or_create_by(movie_id: movie_id, location_id: location_id).id
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:name, :description, :year, :director_id)
    end
end
