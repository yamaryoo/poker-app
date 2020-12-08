Rails.application.routes.draw do
  root 'cards#form'
  get '/result' => 'cards#result'
end
