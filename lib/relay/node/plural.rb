module Relay
  module Node

    class PluralIdentifyingRootFieldConfiguration < GraphQL::Configuration::Base
      slot :name,                   String, coerce: -> (v) { v.to_s }
      slot :input_type,             GraphQL::GraphQLInputType
      slot :output_type,            GraphQL::GraphQLOutputType
      slot :argument_name,          String, coerce: -> (v) { v.to_s }
      slot :resolve_single_input,   Proc
    end

    class PluralIdentifyingRootField < GraphQL::GraphQLField
      configure_with PluralIdentifyingRootFieldConfiguration

      def args
        @args ||= [GraphQL::GraphQLArgument.new(@configuration.argument_name, ! + ! @configuration.input_type)]
      end

      def type
        @type ||= + @configuration.output_type
      end

      def resolve
        lambda { |object, params|
          params[args.first.name.to_sym].map do |item|
            resolve_single_input.call(item)
          end
        }
      end
    end

    class GraphQL::GraphQLObjectTypeConfiguration

      def plural_identifying_root_field(*args, &block)
        field(PluralIdentifyingRootField.new(*args, &block))
      end

    end

  end
end
