class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false
    param_sort_by = params[:sort]
    param_ratings = params[:ratings]
    if param_sort_by == nil
      if session[:sort] == nil
        @hilite = nil
        redirect = false
      else
        @hilite = session[:sort]
        redirect = true
      end
    else
      @hilite = params[:sort]
    end
    
    if param_ratings == nil
      if session[:ratings] == nil 
        @r = @all_ratings
        redirect = false
      else
        @r = session[:ratings]
        redirect = true
      end
    else
            @r = (param_ratings.is_a?(Hash)) ? param_ratings.keys : param_ratings
    end
     session[:ratings] = @r 
    session[:sort] = @hilite
    
    @r.each do |rating|
      params[rating] = true
    end
    
    if redirect
      flash.keep
      redirect_to movies_path(:sort => @hilite, :ratings => @r)
    else
      @movies = (@hilite==nil) ? Movie.where(:rating => @r) : Movie.order(@hilite.to_sym).where(:rating => @r)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
