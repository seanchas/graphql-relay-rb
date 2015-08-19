module Relay
  module Node
    module DataGlobal

      UserStruct = Struct.new('UserGlobal', :id, :name)

      Users = {
        '1' => UserStruct.new('1', 'John Doe'),
        '2' => UserStruct.new('2', 'Jane Smith')
      }

      PhotoStruct = Struct.new('PhotoGlobal', :photo_id, :width)

      Photos = {
        '3' => PhotoStruct.new('3', 300),
        '4' => PhotoStruct.new('4', 400)
      }

      fetcher = lambda { |id, *args|
        type, id = Relay::Node.from_global_id(id)

        case type
        when 'User'
          Users[id]
        when 'Photo'
          Photos[id]
        end
      }

      resolver = lambda { |root|
        case root
        when UserStruct
          UserType
        when PhotoStruct
          PhotoType
        end
      }

      definitions = Relay::Node::CompositeType.new(fetch_object: fetcher, resolve_type: resolver)

      UserType = GraphQL::GraphQLObjectType.new do
        name 'User'

        global_id_field :id, type_name: 'User'

        field :name,    GraphQL::GraphQLString

        interface definitions.interface
      end

      PhotoType = GraphQL::GraphQLObjectType.new do
        name 'Photo'

        global_id_field :id, type_name: 'Photo', resolve_id: -> (object) { object.photo_id }

        field :width,   GraphQL::GraphQLInt

        interface definitions.interface
      end

      QueryType = GraphQL::GraphQLObjectType.new do
        name 'Query'

        field definitions.field

        field :all, + definitions.interface do
          resolve lambda { |*args|
            Users.values.concat(Photos.values)
          }
        end
      end

      Schema = GraphQL::GraphQLSchema.new do
        query QueryType
      end
    end
  end
end
