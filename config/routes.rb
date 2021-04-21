Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      scope :internet_troubles do
        post '/', to: 'public/internet_troubles#show', as: :internet_troubles_show
      end
      namespace :private do
        get 'get_troubles', to: 'admin#get_troubles', as: :admin_get_troubles
        get 'show_trouble/:id', to: 'admin#show_trouble', as: :admin_show_trouble
        scope :users do
          post '/', to: 'users#create', as: :users_create
          post '/login', to: 'users#login', as: :users_login
        end
        scope :internet_troubles do
          get '/', to: 'internet_troubles#index', as: :internet_troubles_index
          post '/', to: 'internet_troubles#create', as: :internet_troubles_create
          put '/:id/edit', to: 'internet_troubles#edit', as: :internet_troubles_edit
        end
      end
    end
  end
end
