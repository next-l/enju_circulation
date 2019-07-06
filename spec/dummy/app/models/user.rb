class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
  include EnjuCirculation::EnjuUser
end

Basket.include(EnjuCirculation::EnjuBasket)
Manifestation.include(EnjuCirculation::EnjuManifestation)
Item.include(EnjuCirculation::EnjuItem)
Profile.include(EnjuCirculation::EnjuProfile)
Library.include(EnjuEvent::EnjuLibrary)
Item.include(EnjuLibrary::EnjuItem)
UserGroup.include(EnjuCirculation::EnjuUserGroup)
Withdraw.include(EnjuCirculation::EnjuWithdraw)
