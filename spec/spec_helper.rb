# frozen_string_literal: true

require 'ruby3_backward_compatibility'
require 'byebug'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:example, :min_ruby) do |example|
    if RUBY_VERSION < example.metadata[:min_ruby]
      skip('Does not apply to this Ruby version.')
    end
  end

  ruby2_specs = 'ruby2/**/*_spec.rb'
  if RUBY_VERSION < '3'
    config.pattern = ruby2_specs
  else
    config.exclude_pattern = ruby2_specs
  end
end
