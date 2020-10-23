Rails.application.routes.draw do
  resources :movies
  get 'import' => 'movies#import', :as => :import
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
