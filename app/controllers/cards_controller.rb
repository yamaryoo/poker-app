class CardsController < ApplicationController
    def form
    end

    def result
        @text = params[:value]
        @value = Card.judge(params[:value])

        if @value.nil?
            @error = '形式が正しくありません'
        end 
    end

end
