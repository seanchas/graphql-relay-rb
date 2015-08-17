require 'graphql'

module Relay


  class GlobalIDFieldConfiguration < GraphQL::GraphQLFieldConfiguration
    slot :type_name, String
    slot :resolve_id, Proc, null: true
  end


  class GlobalIDField < GraphQL::GraphQLField
    configure_with GlobalIDFieldConfiguration
  end


  class GraphQL::GraphQLObjectTypeConfiguration

    GLOBAL_ID_FIELD_DEFAULT_RESOLVE = -> (object) { object.id }

    def global_id_field(*args, &block)
      configuration = GlobalIDFieldConfiguration.new(*args, &block)

      configuration.instance_eval do
        type GraphQL::GraphQLID

        resolve lambda { |object|
          Relay::Node.to_global_id(type_name, (resolve_id || GLOBAL_ID_FIELD_DEFAULT_RESOLVE).call(object))
        }
      end

      field(GlobalIDField.new(configuration))
    end

  end


end
