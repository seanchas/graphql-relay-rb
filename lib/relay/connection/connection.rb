require_relative 'array'

module Relay
  module Connection

    ForwardConnectionArguments = [
      GraphQL::GraphQLArgument.new(:after, GraphQL::GraphQLString),
      GraphQL::GraphQLArgument.new(:first, GraphQL::GraphQLInt)
    ]

    BackwardConnectionArguments = [
      GraphQL::GraphQLArgument.new(:before, GraphQL::GraphQLString),
      GraphQL::GraphQLArgument.new(:last, GraphQL::GraphQLInt)
    ]

    ConnectionArguments = ForwardConnectionArguments.concat(BackwardConnectionArguments)

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


    class CompositeTypeConfiguration < GraphQL::Configuration::Base
      slot :name,               String
      slot :node_type,          GraphQL::GraphQLObjectType
      slot :edge_fields,       [GraphQL::GraphQLField], singular: :edge_field
      slot :connection_fields, [GraphQL::GraphQLField], singular: :connection_field
    end


    class CompositeType < GraphQL::Configuration::Configurable
      configure_with CompositeTypeConfiguration

      def connection
        @connection ||= GraphQL::GraphQLObjectType.new(connection_arguments)
      end

      def edge_type
        @edge_type ||= GraphQL::GraphQLObjectType.new(edge_type_arguments)
      end

      private

      def connection_arguments
        {
          name:         name + 'Connection',
          description:  'A connection to a list of items.',
          fields: @configuration.connection_fields.concat([
            { name: 'pageInfo', type: !PageInfoType,  description: 'Information to aid in pagination.' },
            { name: 'edges',    type: +edge_type,     description: 'Information to aid in pagination.' }
          ])
        }
      end

      def edge_type_arguments
        {
          name: name + 'Edge',
          description: 'An edge in a connection.',
          fields: @configuration.edge_fields.concat([
            { name: :node,    type: @configuration.node_type, description: 'The item at the end of the edge.' },
            { name: :cursor,  type: !GraphQL::GraphQLString,  description: 'A cursor for use in pagination.'  }
          ])
        }
      end
    end


  end
end
