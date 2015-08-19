require 'base64'

require_relative 'node/global_id_field'
require_relative 'node/plural_identifying_root_field'
require_relative 'node/composite'

module Relay

  module Node

    def self.to_global_id(type, id)
      Base64.strict_encode64([type, id].join(':'))
    end

    def self.from_global_id(global_id)
      return Base64.strict_decode64(global_id).split(':')
    end

  end

end
