Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :private do
        scope :users do
          post '/', to: 'users#create', as: :users_create
          post '/login', to: 'users#login', as: :users_login
        end
        scope :internet_troubles do
          post '/', to: 'internet_troubles#create', as: :internet_troubles_create
        end
      end
    end
  end
end
