Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'stations#new'
  get 'stations/suggest', to: 'stations#suggest', defaults: {format: 'json'}
end
