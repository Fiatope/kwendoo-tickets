require 'sidekiq/web'

Neighborly::Application.routes.draw do
  get 'mailing_list/addUser'
  #get '/about', to: redirect('/learn')

  post :hooks, to: 'webhook/events#create'
  post '/wecashup' => 'wecashup#create'
  post '/wecashup-hook' => 'wecashup#update'
  get '/wecashup/error' => "wecashup#wecashup_error"
  get '/wecashup/success/:id' => "wecashup#wecashup_success", as: :wecashup_success

  devise_for :users, path: '',
    path_names:  {
      sign_in:  :login,
      sign_out: :logout,
      sign_up:  :signup
    },
    controllers: {
      omniauth_callbacks: :omniauth_callbacks,
      sessions:           :sessions
    }


  devise_scope :user do
    post '/signup', to: 'devise/registrations#create', as: :signup
  end

  get '/thank_you' => "static#thank_you"

  check_user_admin = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.admin }

  # Mountable engines
  constraints check_user_admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  #mount Neighborly::Api::Engine => '/api/', as: :neighborly_api
  # mount Neighborly::Dashboard::Engine => '/dashboard/', as: :neighborly_dashboard
  mount Neighborly::Mangopay::Creditcard::Engine => '/mangopay/creditcard/', as: :neighborly_mangopay_creditcard
  mount Neighborly::Mangopay::Engine => '/mangopay/', as: :neighborly_mangopay
  # mount Neighborly::Balanced::Creditcard::Engine => '/balanced/creditcard/', as: :neighborly_balanced_creditcard
  # mount Neighborly::Balanced::Bankaccount::Engine => '/balanced/bankaccount/', as: :neighborly_balanced_bankaccount
  #mount Neighborly::Balanced::Engine => '/balanced/', as: :neighborly_balanced

  # Blogo::Routes.mount_to(self, at: '/blog')

  # Non production routes
  if Rails.env.development?
    resources :emails, only: [ :index, :show ]
  end

  # Channels
  constraints ChannelConstraint do
    namespace :channels, path: '' do
      get '/', to: 'profiles#show', as: :profile
      resources :channels_subscribers, only: [:index, :create, :destroy]

      namespace :admin do

        get '/', to: 'dashboard#index', as: :dashboard

        namespace :reports do
          resources :subscriber_reports, only: [ :index ]
        end

        resources :followers, only: [ :index ]

        resources :projects, only: [ :index, :update] do
          member do
            put 'launch'
            put 'reject'
            put 'push_to_draft'
            put 'push_to_request_funds'
            put 'push_to_paid'
            put 'push_to_fraud_suspiscion'
            put 'approve'
          end
        end
      end

      resources :projects, only: [:new, :create]
      # NOTE We use index instead of create to subscribe comming back from auth via GET
      resource :channels_subscriber, only: [:show, :destroy], as: :subscriber
    end
  end

  mount Neighborly::Admin::Engine => '/admin/', as: :neighborly_admin

  scope :admin do
    get '/tickets', to: 'projects/rewards/tickets#index', as: :tickets
  end

  get '/free_ticket/:id', to: 'projects/rewards/tickets#free_ticket', as: :free_ticket
  get '/free_ticket_index/:id', to: 'projects/rewards/tickets#free_ticket_index', as: :free_ticket_index

  # Root path should be after channel constraints
  root to: 'projects#index'

  # Static Pages
  get '/sitemap',               to: 'static#sitemap',             as: :sitemap
  get '/commentçamarche',          to: 'static#how_it_works',        as: :how_it_works
  get "/faq",                   to: "static#faq",                 as: :faq
  get "/conditions",                 to: "static#terms",               as: :terms
  get "/privacy",               to: "static#privacy",             as: :privacy
  get "/démarrer",                 to: "projects#start",             as: :start
  get "/tarifs",                 to: "static#price",               as: :price
  get "/apropos",                 to: "static#about",               as: :about
  get '/pourquoikwendoo',           to: 'static#why_kwendoo',         as: :why_kwendoo
  get "/statistiques",          to: "discover#statistiques",      as: :statistiques
  get "/csr-partners",          to: "static#csr_partners",        as: :csr_partners
  get "/org-partners",          to: "static#org_partners",        as: :org_partners
  get "/successful",            to: "static#successful",          as: :successful
  get "/jobs",                  to: "static#jobs",                as: :jobs
  get "/ambassadeurs",           to: "static#ambassadors",         as: :ambassadors
  get "/éthique",         to: "static#values_ethics",       as: :values_ethics
  get "/originekwendoo",        to: "static#kwendoo_origin",      as: :kwendoo_origin
  get "/exemples",              to: "static#examples",            as: :examples
  get "/définition",            to: "static#definition",          as: :definition
  get "/googlef531541d3ba84380.html", to: "static#googlef531541d3ba84380.html",  as: :googlef531541d3ba84380
  get "/zohoverify/verifyforzoho.html",  to: "static#verifyforzoho",  as: :verifyforzoho


  # Only accessible on development
  if Rails.env.development?
    get "/base",                to: "static#base",              as: :base
  end

  get "/discover/(:state)(/near/:near)(/category/:category)(/tags/:tags)(/search/:search)", to: "discover#index", as: :discover

  resources :tags, only: [:index]

  get 'cards/:id/delete', to: 'neighborly/mangopay/creditcard/payments#delete'

  namespace :reports do
    resources :contribution_reports_for_project_owners, only: [:index]
  end

  # Temporary
  get '/projects/neuse-river-greenway-benches-draft', to: redirect('/projects/neuse-river-greenway-benches')

  #customer message form
  resources :messages, :only => [ :new, :create] do
     get 'thank_you', :on => :collection
  end
  #end

  #customer invitation to contribute form
  resources :invitations, :only => [ :new, :create] do
     get 'thank_you', :on => :collection
  end

 
  post 'webhooks/orange-money-payment-confirmations', to: 'projects/contributions#orange_money_payment_confirmation'
  get  'webhooks/orange-money-payment-confirmations', to: 'projects/contributions#orange_money_payment_confirmation'

  post 'webhooks/pay-plus-africa-payment-confirmations', to: 'projects/contributions#pay_plus_africa_payment_confirmation'
  get  'webhooks/pay-plus-africa-payment-confirmations', to: 'projects/contributions#pay_plus_africa_payment_confirmation'

  post  'webhooks/oltranz-payment-confirmations', :to => 'projects/contributions#mobile_money_payment_confirmation'

  resources :projects, except: [ :destroy ], path: "events" do
    resources :faqs, controller: 'projects/faqs', only: [ :index, :create, :destroy ]
    resources :terms, controller: 'projects/terms', only: [ :index, :create, :destroy ]
    resources :updates, controller: 'projects/updates', only: [ :index, :create, :destroy ]
    resources :promotions, controller: 'projects/promotions', only: [ :new, :create, :edit, :update ]

    collection do
      get 'video'
    end

    member do
      get 'embed'
      get 'video_embed'
      get 'embed_panel'
      get 'comments'
      get 'reports'
      get 'invitations'
      get 'promotions'
      get 'budget'
      get 'success'
      get 'pay'
      get 'presuccess'
      get 'ticketing_database'
    end

    resources :rewards, except: :show do
      member do
        post 'sort'
      end
    end

    resources :contributions, controller: 'projects/contributions', path: "tickets", except: :update do
      member do
        get 'tickets_index'
        get 'tickets_show'
        get 'check_mobile_money_payment_success'
        put 'credits_checkout'
        get 'vpc_payment'
        get 'issue_free_tickets'
        post 'mobile_money_payment_initiation'
        get 'orange_money_payment_initialization'
        get 'pay_plus_africa_payment_initialization'
        get 'touch_payment_new'
        post 'touch_payment_initialization'
        post 'touch_payment_status'
        get 'touch_payment_return'
      end
    end

    resources :matches, controller: 'projects/matches', except: %i(index update destroy) do
      member do
        get 'vpc_payment'
      end
    end        
  end

  resources :contributions do 
    get 'check_mobile_money_payment_success', controller: "projects/contributions"
  end

  scope :login, controller: :sessions do
    devise_scope :user do
      get   :set_new_user_email
      patch :confirm_new_user_email
    end
  end

  resources :users, path: 'neighbors' do
    resources :questions, controller: 'users/questions', only: [:new, :create]
    resources :projects, controller: 'users/projects', only: [ :index ]
    resources :contributions, controller: 'users/contributions', only: [:index] do
      member do
        get :request_refund
      end
    end

    resources :authorizations, controller: 'users/authorizations', only: [:destroy]
    resources :unsubscribes, only: [:create]
    member do
      get :settings
      get :credits
      get :payments
      get :mangopay_authentications
      get :edit
      put :update_email
      put :update_password
      put :update_bank_information
      put :mangopay_upload_kyc_files
    end
  end

  get :contact, to: 'contacts#new'
  resources :contacts, only: [:create]

  resources :images, only: [:new, :create]

  namespace :markdown do
    resources :previewer, only: :create
  end

  # Redirect from old users url to the new
  get "/users/:id", to: redirect('neighbors/%{id}')

  # Temporary Routes
  get '/projects/57/video_embed', to: redirect('projects/ideagarden/video_embed')

  get "/set_email" => "users#set_email", as: :set_email_users
  get "/:id", to: redirect('projects/%{id}')
  post '/adduser', to: 'mailing_list#addUser'
  put '/removeuser', to: 'mailing_list#removeUser'

end
