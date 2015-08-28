require_relative 'definitions'

module Relay
  module Connection

    class CompositeType

      attr_reader :edgeType, :connectionType

      def initialize(*args, &block)
        @edgeType, @connectionType = Relay::Connection.definitions(*args, &block)
      end

    end

  end
end
