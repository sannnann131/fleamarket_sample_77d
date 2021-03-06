class User < ApplicationRecord
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
        devise :database_authenticatable, :registerable,
                :recoverable, :rememberable, :validatable
        has_many :items
        has_many :soldouts
        has_one :residency, dependent: :delete
        has_one :card, dependent: :delete

        #以下はフリマのバリデーションコード
        with_options presence: true do
        validates :nickname
        validates :birth_day
        validates :email, uniqueness: {case_sensitive: true},
                format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}
        validates :password, length: {minimum: 7}
        validates :family_name,
                format: {with: /\A[ぁ-んァ-ン一-龥]/, message: 'を全角で入力してください' }
        validates :first_name,
                format: { with: /\A[ぁ-んァ-ン一-龥]/, message: 'を全角で入力してください' }
        validates :family_name_reading,
                format: { with: /\A([ァ-ン]|ー)+\z/, message: 'を全角カタカナで入力してください' }
        validates :first_name_reading,
                format: { with: /\A([ァ-ン]|ー)+\z/, message: 'を全角カタカナで入力してください' }
        end
end