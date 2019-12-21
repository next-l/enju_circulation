require "rails_helper"

describe ManifestationPolicy do
  subject { described_class }
  permissions :destroy? do
    before(:each) do
      @admin = FactoryBot.create(:admin)
    end

    it "not grants destroy if it is reserved" do
      record = FactoryBot.create(:reserve).manifestation
      expect(subject).not_to permit(@admin, record)
    end
  end
end
