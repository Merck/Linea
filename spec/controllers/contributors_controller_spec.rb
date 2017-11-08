# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'rails_helper'

describe ContributorsController, type: :controller  do
  context 'logged in' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
    end

    describe 'GET index' do
      it 'renders all the contributors' do
        get :index

        expect(response.status).to eq(200)
        expect(response).to render_template(:index)
      end
    end

    describe 'GET show' do
      it 'renders single contributor instance' do
        contributor = create(:contributor)

        get :show, id: contributor.id

        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
      end
    end

    describe 'POST create' do
      it 'creates single instance of a new contributor' do
        user = create(:user)
        dataset = create(:dataset)
        post :create, contributor: { user: user, dataset_id: dataset.id }

        contributor = Contributor.last

        expect(contributor).not_to be_nil
        expect(response.status).to eq(302)
        expect(response).to redirect_to(contributor_path(contributor.id))
      end
    end

    describe 'PUT update' do
      it 'updates existing instance of contributor' do
        contributor = create(:contributor)
        dataset = create(:dataset)

        put :update, id: contributor.id, contributor: { dataset_id:  dataset.id }

        contributor = Contributor.last
        expect(response.status).to eq(302)
        expect(response).to redirect_to(contributor_path(contributor.id))
        expect(contributor.dataset).to eq(dataset)
      end

      it 'redirects away when no contributor id is given' do
        put :update, id: 'nonsense id', contributor: { user: @user }

        expect(response).to redirect_to(contributors_path)
      end
    end

    describe 'DELETE destroy' do
      it 'deletes existing instance of contributor' do
        contributor = create(:contributor)

        delete :destroy, id: contributor.id

        expect(response.status).to eq(302)
        expect(response).to redirect_to(contributors_path)
        expect(Contributor.all.size).to eq(0)
      end
    end
  end

  context 'not logged in' do
    describe 'GET index' do
      it 'does not show all the contributors' do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end
end
