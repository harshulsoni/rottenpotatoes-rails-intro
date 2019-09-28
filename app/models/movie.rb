class Movie < ActiveRecord::Base
    def self.get_rating_list
        self.all.map {|movie| movie.rating}.uniq
    end
    
    def self.with_ratings ratings
        self.where(rating: ratings)
    end
end
