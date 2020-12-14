class CardsController < ApplicationController
    include Util
    def form
    end
    
    def judge
        @errors = validates_cards(params[:text])
        @value = judge_cards(params[:text])
        respond_to do |format|
            format.js
        end
    end

end