require 'active_model'
require 'active_support/core_ext/string/strip'

require File.dirname(__FILE__) + '/valid-env/dsl_methods'
# ValidEnv is the class responsible for specifying which environment variables
# the application expects to interact with. It is so the application can
# validate it's environment during boot.
class ValidEnv
  extend DslMethods
  include ActiveModel::Validations

  class Error < ::StandardError ; end
  class InvalidEnvironment < Error ; end
  class MissingEnvVarRegistration < Error ; end

  def self.describe
    registered_env_vars.each do |key, env_var|
      puts env_var.to_s
    end
  end

  def self.validate!
    instance.validate!
  end

  def validate!
    unless valid?
      error_message = "Environment validation failed:\n\n"
      errors.full_messages.each do |error|
        error_message << "* #{error}\n"
      end
      error_message << "\n"
      fail InvalidEnvironment, error_message
    end
  end
end

require File.dirname(__FILE__) + '/valid-env/env_var'
require File.dirname(__FILE__) + '/valid-env/optional_env_var'
require File.dirname(__FILE__) + '/valid-env/required_env_var'
require File.dirname(__FILE__) + '/valid-env/boolean_validator'
require File.dirname(__FILE__) + '/valid-env/presence_validator'


