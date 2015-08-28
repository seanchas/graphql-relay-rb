require_relative 'types'

module Relay
  module Connection

    class Configuration < GraphQL::Configuration::Base
      slot :name,               String
      slot :nodeType,           GraphQL::GraphQLObjectType
      slot :edgeFields,        [GraphQL::GraphQLField], singular: :edgeField
      slot :connectionFields,  [GraphQL::GraphQLField], singular: :connectionField
    end

    def self.definitions(*args, &block)

      configuration = Configuration.new(*args, &block)

      edgeType = GraphQL::GraphQLObjectType.new do
        name          configuration.name + 'Edge'
        description   'An edge in a connection.'

        fields configuration.edgeFields

        field :node, configuration.nodeType do
          description 'The item at the end of the edge.'
        end

        field :cursor, !GraphQL::GraphQLString do
          description 'A cursor for use in pagination.'
        end
      end

      connectionType = GraphQL::GraphQLObjectType.new do
        name          configuration.name + 'Connection'
        description   'A connection to a list of items.'

        fields configuration.connectionFields

        field :pageInfo, !PageInfoType do
          description 'Information to aid in pagination.'
        end

        field :edges, + edgeType do
          description 'Information to aid in pagination.'
        end
      end

      return edgeType, connectionType
    end

  end
end
