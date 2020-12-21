require 'rails_helper'

describe 'CardJudgeAPI', type: :request do
    context '正しいデータを渡した場合' do
        params = {
            cards: ['S2 D4 H3 C2 S3', 'D3 H2 C2 S4 S5', 'H5 S5 D5 C5 C2', 'S2 C2 H2 D2 S3']
        }

        it '役の名前と、最も強い役を結果として返す' do
            post '/api/v1/cards/judge', params: params
            json = JSON.parse(response.body)
    
            expect(response.status).to eq(201)

            expect(json['result'][0]['card']).to eq(params[:cards][0])
            expect(json['result'][0]['hand']).to eq(Settings.hand[:two_pair].name)
            expect(json['result'][0]['best']).to eq(false)

            expect(json['result'][1]['card']).to eq(params[:cards][1])
            expect(json['result'][1]['hand']).to eq(Settings.hand[:one_pair].name)
            expect(json['result'][1]['best']).to eq(false)

            expect(json['result'][2]['card']).to eq(params[:cards][2])
            expect(json['result'][2]['hand']).to eq(Settings.hand[:four_of_a_kind].name)
            expect(json['result'][2]['best']).to eq(true)

            expect(json['result'][3]['card']).to eq(params[:cards][3])
            expect(json['result'][3]['hand']).to eq(Settings.hand[:four_of_a_kind].name)
            expect(json['result'][3]['best']).to eq(true)
        end    
    end

    context '不正なデータが含まれる場合' do
        params = {
            cards: ['D3 H4 C5 C2 S4', 'A1 C2 d1 C5']
        }

        it 'resultとerrorを返却する' do
            post '/api/v1/cards/judge', params: params
            json = JSON.parse(response.body)

            expect(json['result'][0]['card']).to eq(params[:cards][0])
            expect(json['result'][0]['hand']).to eq(Settings.hand[:one_pair].name)
            expect(json['result'][0]['best']).to eq(true)

            expect(json['error'][0]['card']).to eq(params[:cards][1])
            expect(json['error'][0]['msg']).to eq([
                I18n.t("errors.incorrect_cards"),
                I18n.t("errors.incorrect_card", n: 1),
                I18n.t("errors.incorrect_card", n: 3)]
            )
        end
    end
    
end