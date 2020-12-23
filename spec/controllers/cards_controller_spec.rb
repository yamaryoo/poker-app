require 'rails_helper'

describe 'トップページ', type: :request do
    describe 'GET /' do
        it 'トップページがrenderされる' do
            get root_path
            expect(response).to render_template :form
        end

        it '画面の表示に成功' do
            get root_path
            expect(response).to have_http_status(200)
        end
    end
end

describe '判定処理', type: :request do
    describe 'POST /judge' do
        params = {
            text: 'S1 S2 S3 S4 S5'
            # format: :js
        }

        it 'javascript動作テスト' do
            post judge_path, params: params, xhr: true
            # ここでjavascriptが動作して、form.htmlのresultを書き換えたことをテストしたいが、ひとまずstatuscodeだけ            
            expect(response).to have_http_status(200)
        end
        
    end
end