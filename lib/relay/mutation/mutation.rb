module Relay

  class MutationConfiguration < GraphQL::Configuration::Base
    slot :name,                 String, coerce: -> (v) { v.to_s }
    slot :inputFields,          [GraphQL::GraphQLInputObjectField], singular: :inputField
    slot :outputFields,         [GraphQL::GraphQLField], singular: :outputField
    slot :mutateAndGetPayload,  Proc
  end

  def self.mutationWithCliendMutationId(*args, &block)
    mutation_configuration = MutationConfiguration.new(*args, &block)

    input_fields = mutation_configuration.inputFields << GraphQL::GraphQLInputObjectField.new do
      name 'clientMutationId'
      type !GraphQL::GraphQLString
    end

    output_fields = mutation_configuration.outputFields << GraphQL::GraphQLField.new do
      name :clientMutationId
      type !GraphQL::GraphQLString
    end

    input_type = GraphQL::GraphQLInputObjectType.new do
      name    mutation_configuration.name + 'Input'
      fields  input_fields
    end

    output_type = GraphQL::GraphQLObjectType.new do
      name    mutation_configuration.name + 'Payload'
      fields  output_fields
    end

    GraphQL::GraphQLField.new do
      name  mutation_configuration.name
      type  output_type

      arg   :input, !input_type

      resolve lambda { |root, params, context|
        input = params[:input]
        GraphQL::Execution::Pool.future do
          value = mutation_configuration.mutateAndGetPayload.call(input, context)
          value = value.value if value.is_a?(Celluloid::Future)
          value[:clientMutationId] = input[:clientMutationId]
          value
        end
      }
    end
  end

end
