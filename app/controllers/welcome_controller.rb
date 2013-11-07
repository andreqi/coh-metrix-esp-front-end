require 'net/http'
require 'json'
class HttpRequestClient
  def self.doRequest(url, params)
    url = URI.parse(url)
    req = Net::HTTP::Post.new(url.path)
    req.set_form_data params
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.read_timeout = 500
      http.request(req)
    }
    res.body
  end
end

class CohMetrixEspClient
  def self.callCohMetrix(text)
    ans = JSON::parse(HttpRequestClient::doRequest 'http://localhost:4567/', :text => text)
    [ans["metrics"], ans["class"]]
  end

end 


class WelcomeController < ApplicationController
  def index
  end

  def analyze
    @metrics, @class = CohMetrixEspClient::callCohMetrix params[:texto]
    @text = params[:texto]
  end
end
