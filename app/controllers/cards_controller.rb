class CardsController < ApplicationController
    def form
    end
    
    def judge
        @errors = CardServices.validates_cards(params[:text])
        @value = CardServices.judge_cards(params[:text])

        respond_to :js
    end

end