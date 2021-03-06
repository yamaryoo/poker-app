module CardServices

    # 役の定義
    @@straight_flush = {
        name: 'ストレートフラッシュ',
        strength: 9
    }
    @@four_of_a_kind = {
        name: 'フォー・オブ・ア・カインド',
        strength: 8
    }
    @@full_house = {
        name: 'フルハウス',
        strength: 7
    }
    @@flush = {
        name: 'フラッシュ',
        strength: 6
    }
    @@straight = {
        name: 'ストレート',
        strength: 5
    }
    @@three_of_a_kind = {
        name: 'スリー・オブ・ア・カインド',
        strength: 4
    }
    @@two_pair = {
        name: 'ツーペア',
        strength: 3
    }
    @@one_pair = {
        name: 'ワンペア',
        strength: 2
    }
    @@high_card = {
        name: 'ハイカード',
        strength: 1
    }

    # 正規表現の定義
    @@reg_suit   = 'S|C|H|D'
    @@reg_number = '1[0-3]|[1-9]'
    @@reg_card   = '(S|C|H|D)(1[0-3]|[1-9])'

    # バリデーション
    def self.validates_cards(cards)
        card_array = cards.scan(/\S+/)
        errors = []

        # 半角スペースで区切られた文字が5つ存在するか？
        if card_array.length != 5
            errors.push(I18n.t "errors.incorrect_cards")
        end

        # n番目のカード指定文字が間違っていないか
        card_array.each_with_index do |card, i|
            if !(card.match(/^#{@@reg_card}$/))
                errors.push(I18n.t "errors.incorrect_card", n: i+1, card: card)
            end
        end

        # カードが重複していないか
        if card_array.group_by(&:itself).length < card_array.length
            errors.push(I18n.t "errors.duplicated_card")
        end 
        
        return errors

    end

    # 役の判定
    def self.judge_cards(cards)
        # numberの並び替え
        numbers = cards.scan(/#{@@reg_number}/).map{|x| x.to_i}.sort
        num_dup = numbers.group_by(&:itself)

        # suitの重複を取得
        suits = cards.scan(/#{@@reg_suit}/)
        st_dup = suits.group_by(&:itself)

        # 数字が1グループ存在する場合
        if ((numbers.max - numbers.min == 4) && (st_dup.length == 1))
            result = @@straight_flush

            return result
        end

        # 数字が2グループ存在する場合
        if ((num_dup.length == 2))
            if [1,4].include? num_dup.values[0].length
                result = @@four_of_a_kind

            else
                result = @@full_house
            end

            return result
        end

        # スートが全て同じ場合
        if (st_dup.length == 1)
            result =  @@flush
            
            return result
        end
        
        if ((numbers.max - numbers.min == 4) && (num_dup.length == 5))
            result = @@straight

            return result
        end

        # 数字が3グループ存在する場合
        if ((num_dup.length == 3))
            if num_dup.values[0].length == 2 || num_dup.values[1].length == 2
                result = @@two_pair

            else
                result = @@three_of_a_kind
            end
        
            return result
        end

        if ((num_dup.length == 4))
            result = @@one_pair
        
            return result
        end

        if ((num_dup.length == 5))
            result = @@high_card

            return result
        end
    end

    # best判定
    def self.is_best?(target_result, judge_results)
        strength_list = judge_results.map {|result| result[:strength]}

        target_result[:strength] == strength_list.max

    end

    # jsonの返却
    def self.return_json(cards)
        response = {
            result: [],
            error: []
        }

        valid_cards = cards.select {|card| validates_cards(card).empty?} 
        valid_results = valid_cards.map{|card| judge_cards(card)}

        cards.each do |card|
            if validates_cards(card).any?
                error = {
                    'card' => card,
                    'msg' => validates_cards(card)
                }
                response[:error].push(error)
            else
                judge_result = judge_cards(card)
                result = {
                    'card' => card,
                    'hand' => judge_cards(card)[:name],
                    'best' => is_best?(judge_result, valid_results)
                }
                response[:result].push(result)
            end
        end

        return response
    end

end