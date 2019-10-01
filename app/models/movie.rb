class Movie < ActiveRecord::Base
  def self.get_ratings
    return {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
  end

  def self.with_ratings(movie_ratings)
    movies = Movie.where('rating in (?)',movie_ratings)
    return movies
  end
end
