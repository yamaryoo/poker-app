Rails.application.routes.draw do
  root 'cards#form'
  post '/judge' => 'cards#judge'

  mount Base::API => '/'
end
