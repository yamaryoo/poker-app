module V1
    class Root < Grape::API
        # version :V1
        prefix 'api/'
        format :json

        mount V1::Cards
    end
end