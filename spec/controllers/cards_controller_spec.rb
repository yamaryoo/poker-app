# 参考：https://qiita.com/ryouzi/items/de7336e6175530723b30

require 'rails_helper'

# describe CardsController, type: :controller do
#     describe 'GET #form' do
#         it 'render the :form template' do
#             get :form
#             expect(response).to render_template :form
#         end 
#     end

#     describe 'POST #judge' do
#         describe 'CardServices.validates_cards' do
#             context
#         end

#         describe 'CardServices.judge_cards' do
#             context '同じスートで数字が連続する5枚のカードで構成' do
#                 it
#             end
#         end
# end

describe "JudgeCards", type: :request do
    describe "POST /judge" do
        it 'render the :form' do
            get '/'
            expect(response).to render_template :form
        end
    end
end

describe "CardServicesによる役の判定" do
    context '同じスートで数字が連続する5枚のカードで構成' do
        cards = 'S1 S2 S3 S4 S5'
        
        it 'ストレートフラッシュを返す' do
            result = CardServices.judge_cards(cards)
            expect(result).to eq Settings.hand[:straight_flush]
        end    
    end
    
end