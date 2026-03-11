Rails.application.routes.draw do
  resources :article_collections do
    member do
      get :articles
    end
  end
  resources :collection_tags
  resources :site_name_corrections

  # lookbook for view_component development
  mount Lookbook::Engine, at: "/lookbook" if Rails.env.development?
  # mission_control-jobs for job management
  mount MissionControl::Jobs::Engine, at: "/jobs"

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

  namespace :stats do
    get :index, path: "/"
    get :total_articles, path: "total_articles(/:site_name)"
    get :total_sentences, path: "total_sentences(/:site_name)"
    get :total_token_analyses, path: "total_token_analyses(/:site_name)"
    get :sentence_analysis_ratio, path: "sentence_analysis_ratio(/:site_name)"
    get :sentences_per_article, path: "sentences_per_article(/:site_name)"
    get :tokens_per_sentence, path: "tokens_per_sentence(/:site_name)"
    get :articles_by_site_name
    get :sentences_by_site_name
  end

  resources :collect_articles, only: [:index, :new, :create]

  namespace :sites do
    get :index, path: "/"
    get :total_articles, path: "/total_articles/:site_name"
    get :total_sentences, path: "/total_sentences/:site_name"
    get :total_token_analyses, path: "/total_token_analyses/:site_name"
    get :show, path: "/show/:site_name"
    delete :destroy, path: "/destroy/:site_name"
  end

  get "token_analysis_analyzer" => "token_analysis_analyzer#index"
end
