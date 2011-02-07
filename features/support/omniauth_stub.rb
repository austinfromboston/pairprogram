require 'faraday'
class AuthServiceMock

  TWITTER_INFO = {
    :uid => '12345',
    :link => 'http://twitter.com/plataformatec',
    :name => 'Plataforma Tecnologia',
    :urls => ['http://blog.plataformatec.com.br']
  }

  ACCESS_TOKEN = {
    :access_token => "nevergonnagiveyouup"
  }
  include RR::Adapters::RRMethods

  def setup
    stub(OmniAuth.twitter_strategy).user_info { TWITTER_INFO }
    stub(OmniAuth.twitter_strategy).request_phase 
  end
end
