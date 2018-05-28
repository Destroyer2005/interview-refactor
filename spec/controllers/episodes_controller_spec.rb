require 'rails_helper'

RSpec.describe EpisodesController, :type => :controller do
  let!(:tv_show) { TvShow.create!(title: 'test') }

  before do
    user = User.create!(email: 'foo@example.com', password: '12345678')
    sign_in user, scope: :user
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index, tv_show_id: tv_show.id, :format => :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "loads all of the episodes into @episodes" do
      episode1, episode2 = Episode.create!(tv_show_id: tv_show.id), Episode.create!(tv_show_id: tv_show.id, episode: 2)
      get :index, tv_show_id: tv_show.id, :format => :json

      expect(assigns(:episodes)).to match_array([episode1, episode2])
    end

    it "loads all of the episodes into @episodes" do
      episode1, episode2 = Episode.create!(tv_show_id: tv_show.id), Episode.create!(tv_show_id: tv_show.id, episode: 2)
      get :index, tv_show_id: tv_show.id, :format => :json

      expect(assigns(:episodes)).to match_array([episode1, episode2])
    end

    it "loads error into @error if TvShow from param not found" do
      get :index, tv_show_id: tv_show.id + 1, :format => :json

      expect(assigns(:error)).to match(:error=>"TvShow not found")
    end
  end

  describe "GET #show" do
    let(:episode) { Episode.create!(tv_show_id: tv_show.id) }

    it "responds successfully with an HTTP 200 status code" do
      get :show, id: episode.id, tv_show_id: tv_show.id, :format => :json

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "loads all of the episodes into @episodes" do
      get :show, id: episode.id, tv_show_id: tv_show.id, :format => :json

      expect(assigns(:episode)).to match(episode)
    end

    it "loads error into @error if TvShow from param not found" do
      get :show, id: episode.id, tv_show_id: tv_show.id + 1, :format => :json

      expect(assigns(:error)).to match(:error=>"TvShow not found")
    end
  end

  describe "POST #create" do
    let(:params) { { title: 'House', episode: 1 } }

    it "responds successfully with an HTTP 200 status code" do
      request.accept = "application/json"
      post :create, tv_show_id: tv_show.id, episode: params

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "respond with created tv show" do
      request.accept = "application/json"
      post :create, tv_show_id: tv_show.id, episode: params

      expect(response.body).to include('House')
    end

    it "respond with error if TvShow not found" do
      request.accept = "application/json"
      post :create, tv_show_id: tv_show.id+1, episode: params

      expect(assigns(:error)).to match(:error=>"TvShow not found")
    end

    it "respond with error if double episode number for one show" do
      request.accept = "application/json"
      Episode.create!(tv_show_id: tv_show.id, episode: 1)
      post :create, tv_show_id: tv_show.id, episode: params

      expect(assigns(:episode).errors.full_messages).to match_array(["Episode has already been taken"])
    end
  end

  describe "PUT #update" do
    let(:episode) { Episode.create!(title: 'Foo', tv_show_id: tv_show.id) }
    let(:params) { { title: 'House' } }
    let(:wrong_params) { { episode: 1 } }

    it "responds successfully with an HTTP 200 status code" do
      request.accept = "application/json"
      put :update, id: episode.id, tv_show_id: tv_show.id, episode: {episode: 1}

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "respond with updated tv show" do
      request.accept = "application/json"
      put :update, id: episode.id, tv_show_id: tv_show.id, episode: params

      expect(response.body).to include('House')
    end

    it "respond with error if TvShow not found" do
      request.accept = "application/json"
      put :update, id: episode.id, tv_show_id: tv_show.id + 1, episode: params

      expect(assigns(:error)).to match(:error=>"TvShow not found")
    end

    it "respond with error if double episode number for one show" do
      request.accept = "application/json"
      Episode.create!(tv_show_id: tv_show.id, episode: 1)
      put :update, id: episode.id, tv_show_id: tv_show.id, episode: wrong_params

      expect(assigns(:episode).errors.full_messages).to match_array(["Episode has already been taken"])
    end

  end

  describe 'DELETE #destroy' do
    let(:episode) { Episode.create!(title: 'House', tv_show_id: tv_show.id) }

    it "responds successfully with an HTTP 200 status code" do
      request.accept = "application/json"
      delete :destroy, id: episode.id, tv_show_id: tv_show.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "respond with deleted tv show" do
      request.accept = "application/json"
      delete :destroy, id: episode.id, tv_show_id: tv_show.id

      expect(response.body).to include('House')
    end

    it "respond with error if TvShow not found" do
      request.accept = "application/json"
      delete :destroy, id: episode.id, tv_show_id: tv_show.id + 1

      expect(assigns(:error)).to match(:error=>"TvShow not found")
    end
  end
end
