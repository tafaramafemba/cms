require 'net/http'
require 'uri'
require 'json'

class SmsService
  SMS_API_URL = "https://2waychat.com/2wc/single-sms/v1/api"

  def initialize(api_token, sender_id)
    @api_token = api_token
    @sender_id = sender_id
  end

  def send_sms(destination, message_text, message_reference = SecureRandom.hex(6))
    uri = URI.parse(SMS_API_URL)
    headers = { 'Content-Type' => 'application/json' }
    message_date = Time.now.strftime('%Y%m%d%H%M%S')

    payload = {
      token: @api_token,
      destination: destination,
      messageText: message_text,
      messageReference: message_reference,
      messageDate: message_date
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, headers)
    request.body = payload.to_json

    response = http.request(request)
    JSON.parse(response.body)
    Rails.logger.info("SMS sent successfully to #{destination}")
    Rails.logger.info("This was the Response: #{JSON.parse(response.body)}")
  rescue => e
    Rails.logger.error("SMS sending failed: #{e.message}")
    { "error" => e.message }
  end
end
