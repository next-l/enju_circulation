require "rails_helper"

RSpec.describe ReserveMailer, type: :mailer do
  describe 'accepted' do
    let(:mail) { ReserveMailer.accepted(FactoryBot.create(:reserve)) }

    it "renders the body" do
      expect(mail.body.encoded).to match("Enju Library")
    end
  end

  describe 'cancelled' do
    let(:mail) { ReserveMailer.cancelled(FactoryBot.create(:reserve)) }

    it "renders the body" do
      expect(mail.body.encoded).to match("Enju Library")
    end
  end

  describe 'expired' do
    let(:mail) { ReserveMailer.expired(FactoryBot.create(:reserve)) }

    it "renders the body" do
      expect(mail.body.encoded).to match("Enju Library")
    end
  end

  describe 'retained' do
    let(:mail) { ReserveMailer.retained(FactoryBot.create(:reserve)) }

    it "renders the body" do
      expect(mail.body.encoded).to match("Enju Library")
    end
  end
end
