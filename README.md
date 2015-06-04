Using the [exception_notification](https://github.com/smartinez87/exception_notification) gem in Rails to send exception emails ? This gem provides a notifier class for exception_notification to send exceptions to [graylog2](https://www.graylog.org/).


## Installation

* Add the gem to your Gemfile.

        gem "graylog_exception_notifier"


* Configure the gem in `config/enviroments/production.rb`

        Rails.application.config.middleware.use ExceptionNotification::Rack,
                                          :graylog => {
                                              :hostname => "graylog2.com",
                                              :port => 12201,
                                              :max_chunk_size => 'WAN',
                                              :app_name => 'app_name'
                                          }

## Dependencies

* [exception_notification](https://github.com/smartinez87/exception_notification) `~> 4.0`