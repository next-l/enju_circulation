module EnjuCirculation
  module ManifestationsHelper
    def link_to_reservation(manifestation, reserve)
      if current_user
        if current_user.has_role?('Librarian')
          link_to t('manifestation.reserve_this'), new_reserve_path(manifestation_id: manifestation.id)
        else
          if manifestation.is_checked_out_by?(current_user)
            I18n.t('manifestation.currently_checked_out')
          else
            if manifestation.is_reserved_by?(current_user)
              link_to t('manifestation.cancel_reservation'), reserve, confirm: t('page.are_you_sure'), method: :delete 
            else
              link_to t('manifestation.reserve_this'), new_reserve_path(manifestation_id: manifestation.id)
            end
          end
        end
      else
        unless manifestation.items.for_checkout.empty?
          link_to t('manifestation.reserve_this'), new_reserve_path(manifestation_id: manifestation.id)
        end
      end
    end
  end
end
