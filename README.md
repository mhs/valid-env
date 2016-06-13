# valid-env
## It validates environment variables

We often encounter situations where our apps make use of environment variables, but sometimes only under relatively rare circumstances. It's very easy to deploy an app to a new environment, and then discover some hours (or days!) later that an important environment variable wasn't set, and some small part of the app is broken. Often the error message is cryptic.

The valid-env gem provides a way to list and document not only the variables that are required, but also the relationships between them. It provides a quick way to list what's needed, and also will fail fast if the app is run when a required value is missing.

## Installation

```
$ gem install valid-env
```

## Use

### Required variables

You've built an app that requires an environment variable, `APP_NAME`, is defined -- but that value isn't used until your code has already been running for some time.

Using valid-env, you can define and wrap your environment:

```ruby
class MyEnv < ValidEnv
  required :APP_NAME
end
```

**In the initialization of your app, call `MyEnv.validate!`.** If `APP_NAME` is missing, this will throw a clear, readable error that explains the variable must be set.

and then, replace all references to `ENV['APP_NAME']` with either

```ruby
MyEnv.APP_NAME # returns the raw env variable
MyEnv.app_name # returns the coerced env variable value
```

Having both of these forms is more interesting when handling booleans.

### Booleans

Without valid-env, boolean environment variables can be a pain -- thoughtlessly changing a "true" to a "false" may not change behavior, because both are parsed as strings.

ValidEnv provides a coerced value, which is falsy when the env variable is "false":


```ruby
class MyEnv < ValidEnv
  required :BODGE_ENABLED, :boolean
end

# ...

MyEnv.FOO_ENABLED  # returns the raw env variable (a string)
MyEnv.foo_enabled? # returns a boolean
```

Note in the second reader method generated there is an appended '?'.

### Optional variables

Even if a variable isn't required, it's nice to document that it *can* exist. For this, valid-env offers the `optional` keyword:

```ruby
class MyEnv < ValidEnv
  optional :APP_NAME
end
```

### Conditionally required variables

Some variables are required only if another variable is set.

```ruby
class MyEnv < ValidEnv
  optional :BASIC_AUTH_REQUIRED, :boolean, default: false
  required :BASIC_HTTP_USERNAME, if: :basic_auth_required?
  required :BASIC_HTTP_PASSWORD, if: :basic_auth_required?
end
```

MyEnv will only complain that `BASIC_HTTP_USERNAME` is missing if `BASIC_AUTH_REQUIRED` has been set to true.

### Custom validations

valid-env is built using ActiveModel::Validations; you can write your own validation methods if none of the above are suitable.

```ruby
class MyEnv < ValidEnv
  validate :at_least_one_form_of_auth

  required :PASSWORD_AUTH_ENABLED, :boolean
  required :OAUTH_ENABLED, :boolean

  def at_least_one_form_of_auth
    has_auth = oauth_enabled? || password_auth_enabled?
    unless has_auth
      errors.add(:base, <<-ERR)
        Expected at least one form of authentication to be enabled,
        but none were. Possible forms: OAUTH, PASSWORD_AUTH
      ERR
    end
  end
end
```

### Describing the configuration

`MyEnv.describe` will print out a clear list of what variables are required, which are optional, etc.

### A full example

```ruby
require 'valid-env'

class MyEnv < ValidEnv
  validate :validate_at_least_one_form_of_auth

  # App
  required :APP_NAME
  required :PASSWORD_AUTH_ENABLED, :boolean
  optional :PING_URL
  required :RAILS_ENV

  # Amazon S3
  required :S3_URL
  required :S3_BUCKET
  required :AWS_ACCESS_KEY_ID
  required :AWS_SECRET_ACCESS_KEY
  required :AWS_REGION

  # Basic Auth
  optional :BASIC_AUTH_REQUIRED, :boolean, default: false
  required :BASIC_HTTP_USERNAME, if: :basic_auth_required?
  required :BASIC_HTTP_PASSWORD, if: :basic_auth_required?

  # OAuth
  required :OAUTH_ENABLED, :boolean
  required :OAUTH_SIGNUP_URL, if: :oauth_enabled?

  required :OTHER_API_URL, if: :staging_or_production?

  private

  def staging_or_production?
    %w(staging production).include? rails_env
  end

  def validate_at_least_one_form_of_auth
    has_auth = oauth_enabled? || password_auth_enabled?
    unless has_auth
      errors.add(:base, <<-ERR)
        Expected at least one form of authentication to be enabled,
        but none were. Possible forms: OAUTH, PASSWORD_AUTH
      ERR
    end
  end
end
```
