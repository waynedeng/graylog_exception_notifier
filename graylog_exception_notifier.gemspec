Gem::Specification.new do |s|
  s.name            = "graylog_exception_notifier"
  s.version         = "0.1"
  s.platform        = Gem::Platform::RUBY
  s.summary         = "Send rails exceptions to graylog2 via exception_notification"
  s.description     = "Use exception_notification to send rails exceptions to graylog2."
  s.files           = Dir["{lib}/**/*"] + ["README.md"]
  s.require_path    = 'lib'
  s.authors         = %w(Wayne Deng)
  s.email           = %w(wayne.deng.cn@gmail.com)
  s.homepage        = "https://github.com/waynedeng/graylog_exception_notifier"
  s.license         = 'MIT'
  s.add_dependency "exception_notification", "~> 4.0"
  s.add_dependency "gelf", "~> 1.1.3"
end
