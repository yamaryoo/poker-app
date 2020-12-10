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

def validates_cards(cards)
    card_array = cards.scan(Settings.regex[:card])
    errors = []

    if cards.match(/^(#{Settings.regex[:suit]})(#{Settings.regex[:number]})( (#{Settings.regex[:suit]})(#{Settings.regex[:number]})){4}$/)
        errors.push('エラーですhogehoge')

    elsif card_array.group_by(&:itself).length < 5
        errors.push('エラーですfugafuga')
    end 

    return errors
end
