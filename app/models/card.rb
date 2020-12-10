class Card < ApplicationRecord
    def self.judge(value)
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


    # def self.judge(value)
    #     if (value.match(/^(#{Settings.regex[:suit]})(#{Settings.regex[:number]})( (#{Settings.regex[:suit]})(#{Settings.regex[:number]})){4}$/))
    #         # numberの並び替え
    #         numbers = value.scan(/#{Settings.regex[:number]}/).map{|x| x.to_i}.sort
    #         num_dup = numbers.group_by(&:itself)

    #         # suitの重複を取得
    #         suits = value.scan(/#{Settings.regex[:suit]}/)
    #         st_dup = suits.group_by(&:itself)

    #         # 数字が1グループ存在する場合
    #         if ((numbers.max - numbers.min == 4) && (st_dup.length == 1))
    #             value = 'ストレートフラッシュ！'

    #         # 数字が2グループ存在する場合
    #         elsif ((num_dup.length == 2))
    #             if [1,4].include? num_dup.values[0].length
    #                 value = 'フォー・オブ・ア・カインド！'

    #             else
    #                 value = 'フルハウス！'
    #             end

    #         # スートが全て同じ場合
    #         elsif (st_dup.length == 1)
    #             value =  'フラッシュ！'
            
    #         elsif ((numbers.max - numbers.min == 4) && (num_dup.length == 5))
    #             value = 'ストレート！'

    #         # 数字が3グループ存在する場合
    #         elsif ((num_dup.length == 3))
    #             if num_dup.values[0].length == 2 || num_dup.values[1].length == 2
    #                 value = 'ツーペア！'

    #             else
    #                 value = 'スリー・オブ・ア・カインド！'
    #             end
            
    #         elsif ((num_dup.length == 4))
    #             value = 'ワンペア！'
            
    #         elsif ((num_dup.length == 5))
    #             value = 'ハイカード！'
    #         end

    #         return value
    #     end
    # end
end
