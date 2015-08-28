require 'graphql'
require 'relay'
require_relative 'data'

module StarWars

  NodeComposite = Relay::Node::CompositeType.new do

    fetch_object lambda { |global_id, context|
      type, id = Relay::Node.from_global_id(global_id)
      case type
      when 'Faction'
        Data.faction(id.to_i)
      when 'Ship'
        Data.ship(id.to_i)
      end
    }

    resolve_type lambda { |object|
      case object
      when Data::Faction
        FactionType
      when Data::Ship
        ShipType
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

    interface NodeComposite.interface
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
        Relay::Connection.fromArray(ships, params)
      }
    end

    interface NodeComposite.interface
  end


  QueryType = GraphQL::GraphQLObjectType.new do
    name 'Query'

    field :rebels, FactionType, resolve: -> { Data.rebels }

    field :empire, FactionType, resolve: -> { Data.empire }

    field NodeComposite.field
  end


  Schema = GraphQL::GraphQLSchema.new do
    query QueryType
  end

end
