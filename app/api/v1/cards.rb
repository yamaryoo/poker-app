require Rails.root.join('app', 'services', 'card', 'card_services')
module V1
    class Cards < Grape::API
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
                strength = []
                
                params[:cards].each do |card|
                    if CardServices.validates_cards(card).any?
                        err_hash = {
                            'card' => card,
                            'msg' => CardServices.validates_cards(card)
                        }
                        error.push(err_hash)
                    else
                        rslt_hash = {
                            'card' => card,
                            'hand' => CardServices.judge_cards(card)[:name]
                        }
                        result.push(rslt_hash)
                        strength.push(CardServices.judge_cards(card)[:strength])
                    end
                end

                is_best_flags = strength.map {|strg| strg == strength.max}

                is_best_flags.each_with_index do |flag, index|
                    result[index][:best] = flag
                end

                response[:result] = result
                response[:error] = error
                return response
            end
        end
    end
end