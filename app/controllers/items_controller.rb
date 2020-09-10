class ItemsController < ApplicationController
  def index
    @parent = Category.where(ancestry: nil)
  end

  def new
    @item = Item.new
    @conditions = Condition.all
    @prefectures = Prefecture.all
    # 親カテゴリーのデータを取り出して名前の要素を配列に追加していく
    # pluckメソッドで指定したカラムのレコードの配列を取得する
    # unshiftメソッドで配列の先頭に要素を挿入（カテゴリー選択の初期値"選択して下さい"を挿入)
    @parent_category =Category.where(ancestry: nil).pluck(:name).unshift("選択して下さい")
  end

  # 親カテゴリーが選択された後の子カテゴリーのアクション
  def get_children_category
    # 選択された親カテゴリーに紐づく子カテゴリーの配列を取得
    @children_category = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  # 子カテゴリーが選択された後の孫カテゴリーのアクション
  def get_grandchildren_category
    # 選択された子カテゴリーに紐づく孫カテゴリーの配列を取得
    @grandchildren_category = Category.find(params[:child_id]).children
  end

  def show
  end
end
