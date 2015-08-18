module Relay
  module Node

    class PluralIdentifyingRootFieldConfiguration < GraphQL::Configuration::Base
      slot :name,                   String, coerce: -> (v) { v.to_s }
      slot :input_type,             GraphQL::GraphQLInputType
      slot :output_type,            GraphQL::GraphQLOutputType
      slot :argument_name,          String, coerce: -> (v) { v.to_s }
      slot :resolve_single_input,   Proc
    end

    class GraphQL::GraphQLObjectTypeConfiguration

      def plural_identifying_root_field(*args, &block)
        configuration = PluralIdentifyingRootFieldConfiguration.new(*args, &block)

        plural_identifying_root_field = GraphQL::GraphQLField.new do
          name configuration.name

          type +configuration.output_type

          arg configuration.argument_name, !+!configuration.input_type

          resolve lambda { |object, params|
            params[configuration.argument_name.to_sym].map { |param| configuration.resolve_single_input.call(param) }
          }
        end

        field(plural_identifying_root_field)
      end

    end

  end
end
