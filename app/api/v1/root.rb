module V1
    class Root < Grape::API
        version 'v1', using: :path
        prefix 'api/'
        format :json

        mount V1::Cards
    end
end