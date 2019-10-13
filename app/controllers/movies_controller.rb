class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    full_rating = {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
    if params[:ratings].nil? && params[:order].nil?
      tempKeys = session[:ratings]
      tempOrder = session[:order]
      redirect_to movies_path(:order => tempOrder, :ratings => tempKeys)
    # elsif params[:ratings].nil?
    #   tempKeys = session[:ratings] || @all_ratings
    #   movies_path(:ratings => tempKeys)
    # elsif params[:order].nil?
    #   tempOrder = session[:order]
    end
    @myKeys = params[:ratings].nil? ? session[:ratings] || full_rating : params[:ratings]
    # @myKeys = params[:ratings].keys || session[:ratings] || @all_ratings
    # @myKeys = session[:ratingKeys] || myKeys
    @myOrder = params[:order] || session[:order]

    if @myOrder == 'title'
      @movies = Movie.order(:title).where({rating: @myKeys.keys})
    elsif @myOrder == 'release_date'
      @movies = Movie.order(:release_date).where({rating: @myKeys.keys})
    else
      @movies = Movie.where({rating: @myKeys.keys})
    end
    
    session[:ratings] = @myKeys
    session[:order] = @myOrder
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
end
