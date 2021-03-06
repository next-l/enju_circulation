class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :lockable

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
  include EnjuCirculation::EnjuUser
end

Accept.include(EnjuCirculation::EnjuAccept)
Basket.include(EnjuCirculation::EnjuBasket)
Manifestation.include(EnjuCirculation::EnjuManifestation)
Item.include(EnjuCirculation::EnjuItem)
Item.include(EnjuLibrary::EnjuItem)
Profile.include(EnjuCirculation::EnjuProfile)
Profile.include(EnjuLibrary::EnjuProfile)
UserGroup.include(EnjuCirculation::EnjuUserGroup)
Withdraw.include(EnjuCirculation::EnjuWithdraw)
