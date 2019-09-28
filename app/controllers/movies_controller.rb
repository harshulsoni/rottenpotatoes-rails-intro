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
    @all_ratings = Movie.get_rating_list
    redirect = false
    #session.clear
    if params.key?("ratings")
      @ratings = params["ratings"].keys
      session["ratings"] = params["ratings"]
    elsif session.key?("ratings")
      @ratings = session["ratings"].keys
      params["ratings"] = session["ratings"]
      redirect = true
    else
      @ratings = @all_ratings
    end
    @movies = Movie.with_ratings(@ratings)
    
    sortOrder = ''
    if params.key?(:sortOrder)
      sortOrder = params[:sortOrder]
      session[:sortOrder] = params[:sortOrder]
    elsif session.key?(:sortOrder)
      sortOrder = session[:sortOrder]
      params[:sortOrder] = session[:sortOrder]
      redirect = true
    end
    
    puts params
    
    if redirect
      #redirect_to root_path(redirect_params)
      redirect_to movies_path(params), :method => :get
    end
    
    @movies= case sortOrder
      when "title", "release_date"
        instance_variable_set("@klass_#{sortOrder}", "hilite")
        @movies.order(sortOrder)
      else
        @movies
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
