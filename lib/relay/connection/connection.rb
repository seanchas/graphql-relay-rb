require_relative 'array'

module Relay
  module Connection

    ConnectionArguments = [
      GraphQL::GraphQLArgument.new(:before, GraphQL::GraphQLString),
      GraphQL::GraphQLArgument.new(:after, GraphQL::GraphQLString),
      GraphQL::GraphQLArgument.new(:first, GraphQL::GraphQLInt),
      GraphQL::GraphQLArgument.new(:last, GraphQL::GraphQLInt)
    ]

    class ConnectionConfiguration < GraphQL::Configuration::Base
      slot :name,               String
      slot :node_type,          GraphQL::GraphQLObjectType
      slot :edge_fields,       [GraphQL::GraphQLField], singular: :edge_field
      slot :connection_fields, [GraphQL::GraphQLField], singular: :connection_field
    end

    def self.connection_definitions(configuration)
      name, node_type = configuration.name, configuration.node_type

      edge_type = GraphQL::GraphQLObjectType.new do
        name        name + 'Edge'
        description 'An edge in a connection'

        field :node, node_type do
          description 'The item at the end of the edge'
        end

        field :cursor, ! GraphQL::GraphQLString do
          description 'A cursor for use in pagination'
        end

        fields configuration.edge_fields
      end

      connection_type = GraphQL::GraphQLObjectType.new do
        name          name + 'Connection'
        description   'A connection to a list of items.'

        field :pageInfo, !PageInfoType do
          description 'Information to aid in pagination.'
        end

        field :edges, +edge_type do
          description 'Information to aid in pagination.'
        end

        fields configuration.connection_fields
      end

      return edge_type, connection_type
    end

    PageInfoType = GraphQL::GraphQLObjectType.new do
      name          'PageInfo'
      description   'Information about pagination in a connection.'

      field :hasNextPage, !GraphQL::GraphQLBoolean do
        description 'When paginating forwards, are there more items?'
      end

      field :hasPreviousPage, !GraphQL::GraphQLBoolean do
        description 'When paginating backwards, are there more items?'
      end

      field :startCursor, GraphQL::GraphQLString do
        description 'When paginating backwards, the cursor to continue.'
      end

      field :endCursor, GraphQL::GraphQLString do
        description 'When paginating forwards, the cursor to continue.'
      end
    end

  end
end
