class CheckoutMailer < ApplicationMailer
  def due_date(checkout)
    @library_group = LibraryGroup.site_config
    @checkout = checkout
    system_name = LibraryGroup.system_name(checkout.user.profile.locale)

    from = "#{system_name} <#{@library_group.email}>"
<<<<<<< HEAD
    subject = "[#{system_name}] #{I18n.t('checkout_mailer.due_date')}"
=======
    subject = "#{system_name} #{I18n.t('checkout_mailer.accepted')}"
>>>>>>> fec7b6aa... add CheckoutMailer
    mail(from: from, to: checkout.user.email, cc: from, subject: subject)
  end

  def overdue(checkout)
    @library_group = LibraryGroup.site_config
    @checkout = checkout
    system_name = LibraryGroup.system_name(checkout.user.profile.locale)

    from = "#{system_name} <#{@library_group.email}>"
<<<<<<< HEAD
    subject = "[#{system_name}] #{I18n.t('checkout_mailer.overdue')}"
=======
    subject = "#{system_name} #{I18n.t('checkout_mailer.accepted')}"
>>>>>>> fec7b6aa... add CheckoutMailer
    mail(from: from, to: checkout.user.email, cc: from, subject: subject)
  end
end
