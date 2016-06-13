require 'spec_helper'
require 'climate_control'


describe ValidEnv::RequiredEnvVar do
  describe '#to_s' do
    it 'returns a human readable string' do
      env_var = ValidEnv::RequiredEnvVar.new(:foo, :boolean)
      expect(env_var.to_s).to eq('Environment Variable: foo (required)')
    end

    context 'and additional details is provided' do
      it 'includes the additional details' do
        env_var = ValidEnv::RequiredEnvVar.new(
          :foo,
          :boolean,
          additional_details: 'if bar?'
        )
        expected_message = 'Environment Variable: foo (required if bar?)'
        expect(env_var.to_s).to eq(expected_message)
      end
    end
  end
end
