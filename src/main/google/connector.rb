require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

# google様に接続してServiceを返すクラス
class Connector
  def initialize(credential:, token:)
    @credential = credential.freeze
    @token     = token.freeze

    @oob_uri  = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    @app_name = 'fighters calendar'
    @scope = Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS
  end

  def service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = @app_name
    service.authorization = authorize

    service
  end

  private
  def authorize
    client_id = Google::Auth::ClientId.from_file(@credential)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: @token)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, @scope, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: @oob_uri)
      puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: @oob_uri
      )
    end
    credentials
  end
end