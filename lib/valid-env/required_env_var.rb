class ValidEnv
  class RequiredEnvVar < EnvVar
    def to_s
      msg = "Environment Variable: #{key} (required"
      msg << " #{additional_details}" if additional_details
      msg << ")"
      msg
    end
  end
end
