require 'graphql'

module Relay


  GLOBAL_ID_FIELD_DEFAULT_RESOLVE = -> (object) { object.id }

  class GlobalIDFieldConfiguration < GraphQL::Configuration::Base
    slot :name,       String, coerce: -> (v) { v.to_s }
    slot :type_name,  String, coerce: -> (v) { v.to_s }
    slot :resolve_id, Proc,   null: true
  end


  class GraphQL::GraphQLObjectTypeConfiguration

    def global_id_field(*args, &block)
      configuration = GlobalIDFieldConfiguration.new(*args, &block)

      resolve_id = configuration.resolve_id || GLOBAL_ID_FIELD_DEFAULT_RESOLVE

      global_id_field = GraphQL::GraphQLField.new do
        name configuration.name

        type !GraphQL::GraphQLID

        resolve lambda { |object|
          Relay::Node.to_global_id(configuration.type_name, resolve_id.call(object))
        }
      end

      field(global_id_field)
    end

  end


end
