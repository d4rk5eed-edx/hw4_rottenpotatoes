require 'spec_helper'

describe "Movies" do
  describe "GET /movies/similiar" do
    it "should successfully open page with similiar movies url" do
      get movies_similiar_path(Movie.find_by_title('Star Wars'))
      response.status.should be(200)
    end

    it "should call appropriate controller method on click 'Find Movies With same Director' and grab id of current movie" do
      visit movies_view_path(Movie.find_by_title('Star Wars'))
      click_link "Find Movies With Same Director"
      MoviesController.should_receive(:similiar).with(:id=>Movie.find_by_title('Star Wars'))
    end

    it "should call method of the Movie model whose director matches the current movie" do
      visit movies_view_path(Movie.find_by_title('Star Wars'))
      click_link "Find Movies With Same Director"
      Movie.should_receive(:find_by_director).with(Movie.find_by_title('Star Wars').director)
    end
  end
end
