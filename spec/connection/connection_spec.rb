require 'relay'

RSpec.describe 'Relay Connection' do

  User = Struct.new('UserInRelayConnection', :name)

  Users = [
    User.new('Dan'),
    User.new('Nick'),
    User.new('Lee'),
    User.new('Joe'),
    User.new('Tim')
  ]

  friend_edge, friend_connection = Relay::Connection.connection_definitions(
    Relay::Connection::ConnectionConfiguration.new do
      name        'Friend'
      node_type   -> { ConnectionUserType }

      edge_field :friendship_time, GraphQL::GraphQLString do
        resolve -> { 'Yesterday' }
      end

      connection_field :total_count, GraphQL::GraphQLInt do
        resolve -> { Users.size }
      end
    end
  )

  ConnectionUserType = GraphQL::GraphQLObjectType.new do
    name 'User'

    field :name, GraphQL::GraphQLString

    field :friends do
      type friend_connection
      args Relay::Connection::ConnectionArguments
      resolve lambda { |user, params|
        Relay::Connection.connection_from_array(Users, params)
      }
    end
  end

  ConnectionQueryType = GraphQL::GraphQLObjectType.new do
    name 'Query'

    field :user, ConnectionUserType do
      resolve -> { Users[0] }
    end
  end

  ConnectionSchema = GraphQL::GraphQLSchema.new do
    query ConnectionQueryType
  end


  def q1
    %Q(
      query FriendsQuery {
        user {
          name
          friends(first: 2) {
            total_count
            edges {
              friendship_time
              node {
                name
              }
            }
          }
        }
      }
    )
  end


  it "Should include connections and edge fields" do
    document = GraphQL::Language.parse(q1)
    executor = GraphQL::Executor.new(document, ConnectionSchema)
    puts executor.execute({})
  end


end
