class Movie < ActiveRecord::Base
  def self.get_ratings
    return ['G','PG','PG-13','R']
  end

  def self.with_ratings(movie_ratings)
    movies = Movie.where('rating in (?)',movie_ratings)
    return movies
  end
end
