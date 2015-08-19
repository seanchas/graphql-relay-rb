module Relay
  module Node
    module Data

      UserStruct = Struct.new('User', :id, :name)

      Users = {
        '1' => UserStruct.new('1', 'John Doe'),
        '2' => UserStruct.new('2', 'Jane Smith')
      }

      PhotoStruct = Struct.new('Photo', :id, :width)

      Photos = {
        '3' => PhotoStruct.new('3', 300),
        '4' => PhotoStruct.new('4', 400)
      }

      fetcher = lambda { |id, info|
        if Users[id.to_s]
          return Users[id.to_s]
        end
        if Photos[id.to_s]
          return Photos[id.to_s]
        end
      }

      resolver = lambda { |root|
        if Users[root.id.to_s]
          return UserType
        end

        if Photos[root.id.to_s]
          return PhotoType
        end
      }

      definitions = Relay::Node::CompositeType.new(fetch_object: fetcher, resolve_type: resolver)

      UserType = GraphQL::GraphQLObjectType.new do
        name 'User'

        field :id,    ! GraphQL::GraphQLID
        field :name,    GraphQL::GraphQLString

        interface definitions.interface
      end

      PhotoType = GraphQL::GraphQLObjectType.new do
        name 'Photo'

        field :id,    ! GraphQL::GraphQLID
        field :width,   GraphQL::GraphQLInt

        interface definitions.interface
      end

      QueryType = GraphQL::GraphQLObjectType.new do
        name 'Query'

        field definitions.field
      end

      Schema = GraphQL::GraphQLSchema.new do
        query QueryType
      end
    end
  end
end
