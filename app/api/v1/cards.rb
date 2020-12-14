require Rails.root.join('app', 'services', 'card', 'util')
module V1
    class Cards < Grape::API
        include Util
        resources :cards do
            desc 'テスト'
            get do
              hash = {
                  'np' => 'netprotections',
                  'ps' => 'パイセンのこと'
              } 

              return hash
            end

            desc '判定処理'
            post 'judge' do
                response = {}
                result = []
                error = []

                params[:cards].each do |card|
                    if validates_cards(card).any?
                        err_hash = {
                            'card' => card,
                            'msg' => validates_cards(card)
                        }
                        error.push(err_hash)
                    else
                        rslt_hash = {
                            'card' => card,
                            'hand' => judge_cards(card)
                        }
                        result.push(rslt_hash)
                    end
                end

                response[:result] = result
                response[:error] = error
                return response
            end
        end
    end
end
