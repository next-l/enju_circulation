class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :lockable

  include EnjuSeed::EnjuUser
  include EnjuMessage::EnjuUser
  include EnjuCirculation::EnjuUser
end

Manifestation.include(EnjuManifestationViewer::EnjuManifestation)
Item.include(EnjuLibrary::EnjuItem)
Profile.include(EnjuCirculation::EnjuProfile)
UserGroup.include(EnjuCirculation::EnjuUserGroup)
