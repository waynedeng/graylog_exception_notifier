require 'gelf'
module ExceptionNotifier
  class GraylogNotifier

    def initialize(options = {})
      standard_args = {
          :hostname => "localhost",
          :port => 12201,
          :local_app_name => Socket::gethostname,
          :facility => 'gelf_exceptions',
          :max_chunk_size => 'LAN',
          :level => 3
      }

      @args = standard_args.merge(options)
      @notifier = GELF::Notifier.new(@args[:hostname], @args[:port], @args[:max_chunk_size])
    end

    def call(err, options={})
      env = options[:env]
      begin
        opts = {
            :short_message => err.message,
            :facility => @args[:facility],
            :level => @args[:level],
            :host => @args[:local_app_name],
            :app_name=>@args[:app_name]
        }

        if err.backtrace && err.backtrace.size > 0
          bc = ActiveSupport::BacktraceCleaner.new
          bc.add_filter { |line| line.gsub(Rails.root.to_s, '') }
          bc.add_silencer { |line| line =~ /mongrel|rvm\/gems|rubygems/ }
          _backtrace = bc.clean(err.backtrace)||[]
          if _backtrace.size>0
            opts = opts.merge ({
                                  :full_message => _backtrace.join("\n"),
                                  :file => _backtrace[0].split(":")[0],
                                  :line => _backtrace[0].split(":")[1],
                              })
          end
        end

        unless env.nil?
          request = ActionDispatch::Request.new(env)

          request_items = {:url => request.original_url,
                           :http_method => request.method,
                           :ip_address => request.remote_ip,
                           :parameters => request.filtered_parameters,
                           :timestamp => Time.current}

          opts[:request] = request_items
          opts[:session] = request.session
          opts[:cookies] = request.cookies
          # opts[:environment] = request.filtered_env
        end
        @notifier.notify!(opts)
      rescue Exception => i_err
        puts "Graylog2 Exception logger. Could not send message: " + i_err.message
      end
    end

  end
end