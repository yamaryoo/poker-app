class CardsController < ApplicationController
    def form
        @text = session[:text]

        if session[:result]
            @result = session[:result]

        elsif session[:errors]
            @errors = session[:errors]
        end
    end

    def judge
        session[:text] = nil
        session[:errors] = nil
        session[:result] = nil

        # validation
         @errors = validates_cards(params[:text])

        if @errors.any?
            session[:errors] = @errors
        else
            session[:result] = Card.judge(params[:text])
        end 

        session[:text] = params[:text]

        redirect_to '/'
    end
end

def validates_cards(cards)
    card_array = cards.scan(/\S+/)
    errors = []

    # 半角スペースで区切られた文字が5つ存在するか？
    if card_array.length != 5
        errors.push(I18n.t "errors.incorrect_cards")
    end

    # n番目のカード指定文字が間違っていないか
    card_array.each do |card|
        if !(card.match(/^#{Settings.regex[:card]}$/))
            errors.push(I18n.t "errors.incorrect_card", n: card_array.find_index(card)+1)
        end
    end

    # カードが重複していないか
    if card_array.group_by(&:itself).length < card_array.length
        errors.push(I18n.t "errors.duplicated_card")
    end 
    
    return errors

end
