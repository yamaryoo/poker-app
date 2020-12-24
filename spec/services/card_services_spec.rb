require 'rails_helper'

describe 'バリデーション' do
    context '半角スペースが入っていない' do
        cards = 'S2D5C4D3D2'

        it 'エラーを返す' do
             errors = CardServices.validates_cards(cards)
             expect(errors[0]).to eq I18n.t "errors.incorrect_cards"
        end
    end

    context 'カードが5枚より少ない' do
        cards = 'S2 D5 C4 D3'

        it 'エラーを返す' do
            errors =CardServices.validates_cards(cards)
            expect(errors[0]).to eq I18n.t "errors.incorrect_cards"
        end
    end

    context 'カードが5枚より多い' do
        cards = 'D2 C2 H4 S4 S1 H3'

        it 'エラーを返す' do
            errors =CardServices.validates_cards(cards)
            expect(errors[0]).to eq I18n.t "errors.incorrect_cards"
        end
    end

    context 'suitが間違っている' do
        cards = 'A1 C2 D3 H1 S3'

        it 'エラーを返す' do
            errors =CardServices.validates_cards(cards)
            expect(errors[0]).to eq I18n.t "errors.incorrect_card", n: 1, card: 'A1'
        end
    end

    context '数字が間違っている' do
        cards = 'S20 D3 C1 H4 S3'

        it 'エラーを返す' do
            errors =CardServices.validates_cards(cards)
            expect(errors[0]).to eq I18n.t "errors.incorrect_card", n: 1, card: 'S20'
        end
    end

    context 'カードが重複している' do
        cards = 'D2 H3 C3 D2 S1'

        it 'エラーを返す' do
            errors =CardServices.validates_cards(cards)
            expect(errors[0]).to eq I18n.t "errors.duplicated_card"
        end
    end
end

describe "役の判定" do
    context '同じスートで数字が連続する5枚のカードで構成' do
        cards = 'S1 S2 S3 S4 S5'

        it 'ストレートフラッシュを返す' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:straight_flush]
        end    
    end

    context '同じ数字のカードが4枚含まれる' do
        cards = 'C10 D10 H10 S10 D5'

        it 'フォー・オブ・ア・カインド' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:four_of_a_kind]
        end
    end

    context '同じ数字のカード3枚と、別の同じ数字のカード2枚で構成' do
        cards = 'S10 H10 D10 S4 D4'

        it 'フルハウス' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:full_house]
        end
    end

    context '同じスートのカード5枚で構成' do
        cards = 'H1 H12 H10 H5 H3'

        it 'フラッシュ' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:flush]
        end
    end

    context '数字が連続した5枚のカードによって構成' do
        cards = 'S8 S7 H6 H5 S4'

        it 'ストレート' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:straight]
        end
    end

    context '同じ数字の札3枚と、数字の違う2枚の札から構成' do
        cards = 'S12 C12 D12 S5 C3'

        it 'スリー・オブ・ア・カインド' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:three_of_a_kind]
        end
    end

    context '同じ数の2枚組を2組と他のカード1枚で構成' do
        cards = 'H13 D13 C2 D2 H11'

        it 'ツーペア' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:two_pair]
        end
    end

    context '同じ数字の2枚組とそれぞれ異なった数字の札3枚によって構成' do
        cards = 'C10 S10 S6 H4 H2'

        it 'ワンペア' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:one_pair]
        end
    end

    context '上記のどの役も成立しない' do
        cards = 'D1 D10 S9 C5 C4'

        it 'ハイカード' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:high_card]
        end
    end

end