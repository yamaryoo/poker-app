require Rails.root.join('app', 'services', 'card', 'card_services')
module V1
    class Cards < Grape::API
        resources :cards do
            desc '判定処理'
            post 'judge' do

                if !(request.params.has_key?(:cards)) || request.params[:cards].any? { |card| card.class != String}
                    error! I18n.t('errors.invalid_request'), 400
                end

                response = CardServices.return_json(params[:cards])
                    
                return response
            end
        end
    end
end