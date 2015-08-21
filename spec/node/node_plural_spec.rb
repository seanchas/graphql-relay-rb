require 'relay'

RSpec.describe 'Relay Node Plural' do

  UserType = GraphQL::GraphQLObjectType.new do
    name 'User'

    field :username,  GraphQL::GraphQLString
    field :url,       GraphQL::GraphQLString
  end

  UserStruct = Struct.new('PluralUser', :username, :url)

  QueryType = GraphQL::GraphQLObjectType.new do
    name 'Query'

    plural_identifying_root_field :usernames do
      argument_name :usernames
      input_type    GraphQL::GraphQLString
      output_type   UserType

      resolve_single_input lambda { |username, *args|
        UserStruct.new(username, "www.facebook.com/#{username}")
      }
    end
  end

  Schema = GraphQL::GraphQLSchema.new do

    query QueryType

  end

  def q1
    %Q(
      {
        usernames(usernames: ["dschafer", "leebyron", "schrockn"]) {
          username
          url
        }
      }
    )
  end

  it "Should allow fetching" do
    puts GraphQL::graphql(Schema, q1)
  end

end
