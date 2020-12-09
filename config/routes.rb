Rails.application.routes.draw do
  root 'cards#form'
  post '/judge' => 'cards#judge'
end
