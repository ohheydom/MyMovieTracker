require 'rails_helper'

describe 'Movie Page', :js => true do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let!(:user_movie) { FactoryGirl.create(:connector, user: user, movie_id: 12) }
  before do
    sign_in user
  end

  describe "Unclicking and clicking a checkbox for a movie I've seen, Finding Nemo" do
    before do
      VCR.use_cassette 'movies_spec/watched_film_finding_nemo' do
        visit movie_path(user_movie.movie_id)
      end
    end

    it { should have_title(Movie.find(user_movie.movie_id).title) }
    it { should have_css('tr.movie-watched') }

    it "changes the user's movies by -1 and reclicking by 1" do
      VCR.use_cassette 'movies_spec/watched_film_finding_nemo' do
        expect { uncheck_and_wait('12-button') }.to change(user.movies, :count).by(-1)
        expect { check_and_wait('12-button') }.to change(user.movies, :count).by(1)
      end
    end
  end

  describe "Clicking and unclicking checkbox for movie I haven't seen, Forrest Gump" do
    before do
      VCR.use_cassette 'movies_spec/unwatched_film_forrest_gump' do
        visit movie_path(13)
      end
    end

    it { should have_css('tr.movie-unwatched') }
    it { should have_title('Forrest Gump') }

    it "changes the user's movies by 1 and reclicking by -1" do
      VCR.use_cassette 'movies_spec/unwatched_film_forrest_gump' do
        expect { check_and_wait('13-button') }.to change(user.movies, :count).by(1)
        expect { uncheck_and_wait('13-button') }.to change(user.movies, :count).by(-1)
      end
    end
  end

  describe 'Page Elements' do
    context 'valid information' do
      before do
        VCR.use_cassette 'movies_spec/watched_film_finding_nemo' do
          visit movie_path(12)
        end
      end

      it 'displays an image if a poster_path is valid' do
        expect(page).to have_css "td.header-table-movie-picture img[src='http://image.tmdb.org/t/p/w92/zjqInUwldOBa0q07fOyohYCWxWX.jpg']"
      end
    end

    context 'invalid information' do
      before do
        VCR.use_cassette 'movies_spec/film_with_nil_poster_path_rock_a_bye_gator' do
          visit movie_path(234526)
        end
      end

      it 'displays nothing if a poster_path is missing' do
        expect(page).to have_css "td.header-table-movie-picture img[src='']"
      end
    end
  end
end
