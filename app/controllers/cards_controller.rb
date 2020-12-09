class CardsController < ApplicationController
    def form
        @text = session[:value]
        @result = session[:result]

        if @result.nil? && @text
            @error = '形式が正しくありません'
        end
    end

    def judge
        session[:value] = params[:value]
        session[:result] = Card.judge(params[:value])

        redirect_to '/'
    end

end
