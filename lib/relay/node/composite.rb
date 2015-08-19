module Relay
  module Node

    class CompositeTypeConfiguration < GraphQL::Configuration::Base
      slot :fetch_object, Proc
      slot :resolve_type, Proc
    end

    class CompositeType < GraphQL::Configuration::Configurable
      configure_with CompositeTypeConfiguration

      def fetch_object
        @fetch_object ||= lambda { |object, params, context|
          @configuration.fetch_object.call(params[:id], context)
        }
      end

      def resolve_type
        @configuration.resolve_type
      end

      def field
        @field ||= GraphQL::GraphQLField.new(type: interface, resolve: fetch_object) do
          name          'node'
          description   'An object with id.'

          arg :id, !GraphQL::GraphQLID
        end
      end

      def interface
        @interface ||= GraphQL::GraphQLInterfaceType.new(resolve_type: resolve_type) do
          name          'NodeInterface'
          description   'A node with id.'

          field :id, ! GraphQL::GraphQLID
        end
      end
    end

  end
end
