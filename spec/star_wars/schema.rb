require 'graphql'
require 'relay'
require_relative 'data'

module StarWars


  NodeInterface = GraphQL::GraphQLInterfaceType.new do
    name          'NodeInterface'
    description   'An object with id.'

    field :id, ! GraphQL::GraphQLID, description: 'The id of the object.'

    resolve_type lambda { |object|
      case object
      when Data::Faction
        FactionType
      when Data::Ship
        ShipType
      else
        nil
      end
    }
  end


  NodeField = GraphQL::GraphQLField.new do
    name          'node'
    description   'Fetches an object given its global id.'
    type          NodeInterface

    arg :id, ! GraphQL::GraphQLID, description: 'The global id of the object.'

    resolve lambda { |object, params, context|
      type, id  = Relay::Node.from_global_id(params[:id])
      id        = id.to_i

      case type
      when 'Faction'
        Data.faction(id)
      when 'Ship'
        Data.ship(id)
      else
        nil
      end
    }
  end


  ShipEdge = GraphQL::GraphQLObjectType.new do
    name          'ShipEdge'
    description   'Ship edge for ships connection.'

    field :node,  -> { ShipType }
    field :cursor,   ! GraphQL::GraphQLString
  end


  ShipsConnection = GraphQL::GraphQLObjectType.new do
    name          'ShipsConnection'
    description   'A connection to a list of ships.'

    field :pageInfo,  ! Relay::Connection::PageInfoType
    field :edges,     + ShipEdge
  end


  ShipType = GraphQL::GraphQLObjectType.new do
    name          'Ship'
    description   'A ship in the Star Wars saga.'

    global_id_field :id, type_name: 'Ship'

    field :name, GraphQL::GraphQLString, description: 'The name of the ship.'

    interface NodeInterface
  end


  FactionType = GraphQL::GraphQLObjectType.new do
    name          'Faction'
    description   'A faction in the Star Wars saga.'

    global_id_field :id, type_name: 'Faction'

    field :name, GraphQL::GraphQLString, description: 'The name of the faction.'

    field :ships, ShipsConnection do
      args  Relay::Connection::ConnectionArguments
      resolve lambda { |faction, params|
        ships = faction.ships.map { |id| Data.ship(id) }
        Relay::Connection.connection_from_array(ships, params)
      }
    end

    interface NodeInterface
  end


  QueryType = GraphQL::GraphQLObjectType.new do
    name 'Query'

    field :rebels, FactionType, resolve: -> { Data.rebels }

    field :empire, FactionType, resolve: -> { Data.empire }

    field NodeField
  end


  Schema = GraphQL::GraphQLSchema.new do
    query QueryType
  end

end
