require 'rails_helper'

describe ReserveStatHasManifestation do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: reserve_stat_has_manifestations
#
#  id                            :bigint(8)        not null, primary key
#  manifestation_reserve_stat_id :bigint(8)        not null
#  manifestation_id              :bigint(8)        not null
#  reserves_count                :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
