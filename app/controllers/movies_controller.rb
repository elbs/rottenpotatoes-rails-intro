class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # "it expects the variable @all_ratings to be an enumerable collection
    @all_ratings = ['G', 'PG', 'PG-13', 'R']

    @modhl = params[:mode]
    @which_ratings = params[:ratings]
    if which_ratings.empty?
      selected_movies = Movie.all
    #else
    #  selected_movies = grab_rated_movies(@which_ratings)
    @movies = msort(selected_movies)
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  # Elba - make a sorting algorithm here
  # Returns sorted list of movies and also which th cell to highlight
  def msort chosen_movies
    if @modhl == 'title'
      sorted = chosen_movies.all.sort_by(&:title)
    elsif @modhl == 'release'
      sorted = chosen_movies.all.sort_by(&:release_date)
    else
      sorted = chosen_movies.all
    end
    return sorted
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
