# frozen_string_literal: true
require_relative '../../../../test_helper'

SingleCov.covered!

describe Samson::Secrets::Shared::ListRecursive do
  class DummyVaultClient
    def list(_path)
    end
  end

  describe '#list_recursive' do
    it 'can recursively return secrets' do
      DummyVaultClient.prepend(Samson::Secrets::Shared::ListRecursive)
      expected_arguments = ['secrets/apps/', 'secrets/apps/bar/']

      client_instance = DummyVaultClient.new
      client_instance.expects(:original_list).
        twice.
        with { |arg| arg == expected_arguments.shift }.
        returns(['foo', 'bar/'], ['baz'])

      client_instance.list_recursive('secrets/apps/').must_equal ['foo', 'bar/baz']
    end
  end
end
