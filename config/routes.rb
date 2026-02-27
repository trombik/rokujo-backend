Rails.application.routes.draw do
  resources :article_collections
  resources :collection_tags
  resources :site_name_corrections
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "root#index"

  get "search" => "sentences#index"
  get "show_sentences_with_particle_and_verb" => "sentences#show_sentences_with_particle_and_verb"
  get "articles/:uuid", to: "articles#show", as: "article"
  get "articles/:uuid/:line_number", to: "articles#context", as: "article_context"
  get "articles", to: "articles#index"

  resource :token_analysis_manager do
    get :status
    post :start
    post :stop
  end

  namespace :collocations do
    scope controller: :nouns, path: :nouns, as: :nouns do
      get :index, path: "/"
      get :verbs
      get :adjectives
    end
  end

  get "token_analysis_analyzer" => "token_analysis_analyzer#index"
end
