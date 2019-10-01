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
    #want to process the params to store in session
    # then want to process session to create index page
    # also: if all checkboxes are left empty, don't update session
    #
    # param changes:
    #   changes in checkbox
    #     params: assortment of params checked
    #   changes in sorting
    #     params: title, date, none
    #
    # if uri is lacking sorting and checkbox information, will redirect to new uri with these parameters filled out
    # uri: checkboxes & sort


    #populates the possible rating enumerations
    @all_ratings = Movie.get_ratings;

    #if first session, want to populate session with all checkboxes
    if not session[:ratings]
      session[:ratings] = @all_ratings
    end
    #if first session ,want to set session to no sort
    if not session[:sort]
      session[:sort] = "none"
    end

    #session stores new configuration if so
    if(params[:sort])
      session[:sort] = params[:sort]
    end
    if(params[:ratings])
      session[:ratings] = params[:ratings]
    end

    if(not params[:sort] or not params[:ratings])
      flash.keep
      redirect_to movies_path :sort => session[:sort], :ratings => session[:ratings]
    end

    #filter by ratings
    # want to then repopulate the filter options from selected ratings, if not(then first visit and populate all)
    @movies = Movie.with_ratings(session[:ratings].keys)
    @rating_checks = session[:ratings].keys

    #movie ordering
    movies_order = session[:sort]
    if(movies_order == "title")
      @movies = @movies.order(:title)
      @highlight_movie = "hilite"
    elsif (movies_order == "date")
      @movies = @movies.order(:release_date)
      @highlight_date = "hilite"
    end
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
