class CardsController < ApplicationController
    def form
        @text = session[:text]
        @result = session[:result]

        if @result.nil? && @text
            @error = '形式が正しくありません'
        end
    end

    def judge
        session[:text] = params[:text]
        session[:result] = Card.judge(params[:text])

        redirect_to '/'
    end

end
