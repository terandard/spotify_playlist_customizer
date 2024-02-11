# frozen_string_literal: true

class ApplicationApiClient < MyApiClient::Base
  # This is a super class for all API Client classes.
  # Almost settings are inherited to child classes.

  # Set the log output destination. The default is `Logger.new(STDOUT)`.
  self.logger = Rails.logger

  # Set the maximum number of seconds to wait on HTTP connection. If the
  # connection does not open even after this number of seconds, the exception
  # `MyApiClient::NetworkError` will raise. Setting nil will not time out.
  # The default is 60 seconds.
  #
  http_open_timeout 2.seconds

  # Set the maximum number of seconds to block at one HTTP read. If it does not
  # read even after this number of seconds, it will raise the exception
  # MyApiClient::NetworkError. Setting nil will not time out. The default is 60
  # seconds.
  #
  http_read_timeout 3.seconds
end
