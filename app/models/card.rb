class Card < ApplicationRecord
    def self.judge(value)
        # suit = 'S|C|H|D'
        # number = '1[0-3]|[1-9]'

        if (value.match(/^(#{Settings.regex[:suit]})(#{Settings.regex[:number]})( (#{Settings.regex[:suit]})(#{Settings.regex[:number]})){4}$/))
            # numberの並び替え
            numbers = value.scan(/#{Settings.regex[:number]}/).map{|x| x.to_i}.sort
            num_dup = numbers.group_by(&:itself)

            # suitの重複を取得
            suits = value.scan(/#{Settings.regex[:suit]}/)
            st_dup = suits.group_by(&:itself)

            # 数字が1グループ存在する場合
            if ((numbers.max - numbers.min == 4) && (st_dup.length == 1))
                value = 'ストレートフラッシュ！'

            # 数字が2グループ存在する場合
            elsif ((num_dup.length == 2))
                if [1,4].include? num_dup.values[0].length
                    value = 'フォー・オブ・ア・カインド！'

                else
                    value = 'フルハウス！'
                end

            # スートが全て同じ場合
            elsif (st_dup.length == 1)
                value =  'フラッシュ！'
            
            elsif ((numbers.max - numbers.min == 4) && (num_dup.length == 5))
                value = 'ストレート！'

            # 数字が3グループ存在する場合
            elsif ((num_dup.length == 3))
                if num_dup.values[0].length == 2 || num_dup.values[1].length == 2
                    value = 'ツーペア！'

                else
                    value = 'スリー・オブ・ア・カインド！'
                end
            
            elsif ((num_dup.length == 4))
                value = 'ワンペア！'
            
            elsif ((num_dup.length == 5))
                value = 'ハイカード！'
            end

            return value
        end
    end


    # def self.judge(value)
    #     suit = 'S|C|H|D'
    #     number = '1[0-3]|[1-9]'

    #     if (value.match(/^(#{suit})(#{number})( (#{suit})(#{number})){4}$/))
    #         # numberの並び替え
    #         numbers = value.scan(/#{number}/).map{|x| x.to_i}.sort
    #         num_dup = numbers.group_by(&:itself)

    #         # suitの重複を取得
    #         suits = value.scan(/#{suit}/)
    #         st_dup = suits.group_by(&:itself)

    #         # ストレートフラッシュかどうかを判定
    #         if ((numbers.max - numbers.min == 4) && (st_dup.length == 1))
    #             value = 'ストレートフラッシュ！'

    #         # 数字が2グループ存在する場合
    #         elsif ((num_dup.length == 2))
    #             num_dup.values.each do |n|
    #                 # フォー・オブ・ア・カインドを判定
    #                 if (n.length == 4)
    #                     value = 'フォー・オブ・ア・カインド！'
    #                     break

    #                 # フルハウスを判定
    #                 else
    #                     value = 'フルハウス！'
    #                 end
    #             end

    #         # フラッシュを判定
    #         elsif (st_dup.length == 1)
    #             value =  'フラッシュ！'
            
    #         # ストレートかどうかを判定
    #         elsif ((numbers.max - numbers.min == 4) && (suits.length > 1))
    #             value = 'ストレート！'

    #         # 数字が3グループ存在する場合
    #         elsif ((num_dup.length == 3))
    #             num_dup.values.each do |n|
    #                 # スリー・オブ・ア・カインドを判定
    #                 if (n.length == 3)
    #                      value = 'スリー・オプ・ア・カインド！'
    #                      break
    #                 # ツーペアを判定
    #                 else
    #                     value = 'ツーペア！'
    #                 end
    #             end
            
    #         # ワンペアを判定
    #         elsif ((num_dup.length == 4))
    #             value = 'ワンペア！'
            
    #         # ハイカードを判定
    #         elsif ((num_dup.length == 5))
    #             value = 'ハイカード！'
    #         end

    #         return value
    #     end
    # end
end
