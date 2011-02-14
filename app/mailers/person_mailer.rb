class PersonMailer < ActionMailer::Base
  default :from => "pairprogram@gmail.com"
  def offer_email(offer)
    @sender = offer.sender
    @recipient = offer.recipient
    mail(:to => offer.recipient.email, :subject => "#{offer.sender.name} is offering to pair with you")
  end
end
