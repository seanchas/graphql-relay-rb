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

  end
end
