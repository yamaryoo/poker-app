module V1
    class Cards < Grape::API
        resources :cards do
            desc 'テスト'
            get do
                'テスト'
            end
        end
    end
end