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

  FriendConnection = Relay::Connection::CompositeType.new do
    name        'Friend'
    node_type   -> { ConnectionUserType }

    edge_field :friendship_time, GraphQL::GraphQLString do
      resolve -> { 'Yesterday' }
    end

    connection_field :total_count, GraphQL::GraphQLInt do
      resolve -> { Users.size }
    end
  end

  ConnectionUserType = GraphQL::GraphQLObjectType.new do
    name 'User'

    field :name, GraphQL::GraphQLString

    field :friends do
      type FriendConnection.connection
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
          friends(first: 2, after: "YXJyYXljb25uZWN0aW9uOjM=") {
            total_count
            edges {
              friendship_time
              cursor
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
