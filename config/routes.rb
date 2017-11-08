# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'sidekiq/api'

Rails.application.routes.draw do
  namespace :admin do
    resources :terms_of_use, controller: :terms_of_use
    resources :users
    root to: "users#index"
  end

  root to: 'search#search'

  resources :request_accesses do
    member do
      post :approve
      post :reject
    end
  end

  resources :dataset_algorithms

  resources :update_activities


  # temporarily disabled by BDP-820
  get 'newsfeed' => 'newsfeed#index'
  get 'newsfeed/load_more'

  resources :datasources

  resources :like_activities

  resources :review_activities

  resources :share_activities

  resources :search_activities

  resources :view_activities

  resources :ingest_activities

  resources :contributors

  resources :columns

  resources :algorithms

  resources :user_elasticsearch_solutions

  get 'sessions/login', as: 'log_in'
  get 'logout' => 'sessions#destroy', :as => 'log_out'
  get 'auth/:provider/callback', to: 'sessions#create'
  #post 'sessions/login_attempt'
  get 'sessions/impersonate'
  get 'sessions/cancel_impersonation'

  resources :dataset_visual_tools

  resources :tags do
    collection do
      get :autocomplete
      get :popular
    end
  end

  resources :lineages do
    member do
      get :details
    end
  end

  resource :terms_of_use, controller: :terms_of_use, only: [:create] do
    member do
      get :accept
      get :actual
    end
  end

  resource :tables do
    resources :columns
  end

  resources :datasets, only: :show do
    # resources :transformations
    resources :attributes, controller: :dataset_attributes, except: [:index, :show], as: :dataset_attributes do
      collection do
        get :autocomplete
      end
    end

    resources :notes, only: [:edit, :create, :update, :destroy]

    resource :tables do
      resources :columns
    end

    member do
      get :like
      get :share
      get :explore_lineage
      get :lineage_dataset_details

      post :update_columns
      post :update_tags
      post :upload_metadata
      get :redisplay_columns

      post 'ask-for-request' => 'dataset/request_accesses#create'
      get 'connection_info' => 'dataset/connection_info#show',
          as: :connection_info

      namespace :dataset, path: '' do
        resources :request_accesses, only: [:index], param: :request_access_id do
          member do
            post :approve
            post :reject
          end
        end
      end
    end
  end

  resources :terms_of_services

  resources :subject_areas

  get 'search/search'
  get 'search/related_tags'
  get 'search/related_people'
  get 'search' => 'search#search', as: :search
  get 'search/autocomplete'

  get 'mydatasets' => 'users#mydatasets', as: :mydatasets

  resources :users

  resources :my_datasets, only: [:new, :create, :edit, :update, :destroy] do
    resource :transformation, only:  [:create, :edit, :update]
    member do
      get :check_on_status
      get :template_for_initial_scenario
    end
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      post 'sessions' => 'sessions#create'
      jsonapi_resources :datasets
      jsonapi_resources :dataset_attributes
      jsonapi_resources :notes
      jsonapi_resources :tags
      jsonapi_resources :subject_areas
      jsonapi_resources :datasources
      jsonapi_resources :users do
        collection do
          post :verify
        end
      end
    end
  end

  # sidekiq
  mount Sidekiq::Web, :at => 'sidekiq', :constraints => SidekiqWebConstraint.new
  get "sidekiq/status" => proc { [200, { "Content-Type" => "text/plain" }, [Sidekiq::Queue.new.size < 10000 ? "OK" : "UHOH"]] }

  match '*path' => 'application#routing_error', via: :all
 # get ':controller/:action'
end
