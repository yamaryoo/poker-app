class CardsController < ApplicationController
    def form
    end
    
    def judge
        @errors = CardServices.validates_cards(params[:text])
        @value = CardServices.judge_cards(params[:text])
        respond_to do |format|
            format.js
        end
    end

end