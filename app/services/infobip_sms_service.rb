require 'faraday'
require 'json'

class InfobipSmsService
  def initialize
    @api_key = '5bd57b5cb1e59bc7b25f773c0a7e5fb9-7f7573fb-d7ee-4724-8ffe-c01ffa2356a6'
    @base_url = 'https://yxkv1.api.infobip.com/'
  end

  def send_sms(to, message)
    url = "#{@base_url}/sms/2/text/advanced"
    headers = {
      'Authorization' => "App #{@api_key}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    body = {
      "messages": [
        {
          "from": "InfoSMS",
          "destinations": [
            {
              "to": to
            }
          ],
          "text": message
        }
      ]
    }

    response = Faraday.post(url, body.to_json, headers)
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("Failed to send SMS: #{e.message}")
    { error: e.message }
  end
end
