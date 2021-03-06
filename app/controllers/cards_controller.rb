class CardsController < ApplicationController
  before_action :move_to_login
  before_action :set_category
  before_action :set_card

  require "payjp"

  def index
  end

  def new
    @card = Card.new
  end


  def create
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    if params['payjp-token'].blank?
      redirect_to action: :new
    else
      customer = Payjp::Customer.create(
        email: current_user.email,
        card: params['payjp-token'],
        metadata: {user_id: current_user.id} 
      )
      @card = Card.new(user: current_user, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to card_path(current_user),notice: 'クレジットカード情報を登録しました。'
      else
        redirect_to action: :new
      end
    end
  end

  def show
    if @card.present?
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @card_information = customer.cards.retrieve(@card.card_id)
    end
  end

  def destroy
    customer = Payjp::Customer.retrieve(@card.customer_id)
    customer.delete
    if @card.destroy
      redirect_to action: index, notice: "削除しました"
    else
      redirect_to action: :index, alert: "削除できませんでした"
    end
  end


  private
  def move_to_login
    redirect_to  new_user_session_path  unless user_signed_in?
  end

  def set_category
    @parent = Category.where(ancestry: nil)
  end

  def set_card
    @card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).present?
  end
end