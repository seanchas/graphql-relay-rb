module Relay
  module Node

    class PluralIdentifyingRootFieldConfiguration < GraphQL::GraphQLFieldConfiguration
      slot :input_type,             GraphQL::GraphQLInputType
      slot :output_type,            GraphQL::GraphQLOutputType
      slot :resolve_single_input,   Proc
    end

    class PluralIdentifyingRootField < GraphQL::GraphQLField
      configure_with PluralIdentifyingRootFieldConfiguration

      def args
        @args ||= [GraphQL::GraphQLArgument.new(@configuration.name, ! + ! @configuration.input_type)]
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
