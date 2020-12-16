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
                is_best_flags.each {|flag| }

                response[:result] = result
                response[:error] = error
                return response
            end
        end
    end
end


# def validates_cards(cards)
#     card_array = cards.scan(/\S+/)
#     errors = []

#     # 半角スペースで区切られた文字が5つ存在するか？
#     if card_array.length != 5
#         errors.push(I18n.t "errors.incorrect_cards")
#     end

#     # n番目のカード指定文字が間違っていないか
#     card_array.each do |card|
#         if !(card.match(/^#{Settings.regex[:card]}$/))
#             errors.push(I18n.t "errors.incorrect_card", n: card_array.find_index(card)+1)
#         end
#     end

#     # カードが重複していないか
#     if card_array.group_by(&:itself).length < card_array.length
#         errors.push(I18n.t "errors.duplicated_card")
#     end 
    
#     return errors

# end

# def judge_cards(cards)
#     # numberの並び替え
#     numbers = cards.scan(/#{Settings.regex[:number]}/).map{|x| x.to_i}.sort
#     num_dup = numbers.group_by(&:itself)

#     # suitの重複を取得
#     suits = cards.scan(/#{Settings.regex[:suit]}/)
#     st_dup = suits.group_by(&:itself)

#     # 数字が1グループ存在する場合
#     if ((numbers.max - numbers.min == 4) && (st_dup.length == 1))
#         result = Settings.hand[:straight_flush]

#     # 数字が2グループ存在する場合
#     elsif ((num_dup.length == 2))
#         if [1,4].include? num_dup.values[0].length
#             result = Settings.hand[:four_of_a_kind]

#         else
#             result = Settings.hand[:full_house]
#         end

#     # スートが全て同じ場合
#     elsif (st_dup.length == 1)
#         result =  Settings.hand[:flush]
    
#     elsif ((numbers.max - numbers.min == 4) && (num_dup.length == 5))
#         result = Settings.hand[:straight]

#     # 数字が3グループ存在する場合
#     elsif ((num_dup.length == 3))
#         if num_dup.values[0].length == 2 || num_dup.values[1].length == 2
#             result = Settings.hand[:two_pair]

#         else
#             result = Settings.hand[:three_of_a_kind]
#         end
    
#     elsif ((num_dup.length == 4))
#         result = Settings.hand[:one_pair]
    
#     elsif ((num_dup.length == 5))
#         result = Settings.hand[:high_card]
#     end

#     return result
# end

# def best_of_cards(results)
#     strength_array = results.map {|result| result[:strength]}
#     best_flags = results.map{|result| result[:strength] == results.max}
    
#     return best_flags
# end