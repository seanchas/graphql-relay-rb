require_relative 'data'
require_relative 'schema'

RSpec.describe "Star Wars object identification" do

  it "Should correctly fetch the ID and name of the rebels" do

    query = %Q(
      query rebelsQuery {
        rebels {
          id
          name
        }
      }
    )

    expectation = {
      data: {
        rebels: {
          id: 'RmFjdGlvbjox',
          name: 'Alliance to Restore the Republic'
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, query)

    expect(result).to eql(expectation)
  end

  it "Should correctly refetch the rebels" do

    query = %Q(
      query rebelsRefetchQuery {
        node(id: "RmFjdGlvbjox") {
          id
          ... on Faction {
            name
          }
        }
      }
    )

    expectation = {
      data: {
        node: {
          id: 'RmFjdGlvbjox',
          name: 'Alliance to Restore the Republic'
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, query)

    expect(result).to eql(expectation)
  end


  it "Should correctly fetch the ID and name of the empire" do

    query = %Q(
      query empireQuery {
        empire {
          id
          name
        }
      }
    )

    expectation = {
      data: {
        empire: {
          id: 'RmFjdGlvbjoy',
          name: 'Galactic Empire'
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, query)

    expect(result).to eql(expectation)
  end


  it "Should correctly refetch the empire" do

    query = %Q(
      query empireRefetchQuery {
        node(id: "RmFjdGlvbjoy") {
          id
          ... on Faction {
            name
          }
        }
      }
    )

    expectation = {
      data: {
        node: {
          id: 'RmFjdGlvbjoy',
          name: 'Galactic Empire'
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, query)

    expect(result).to eql(expectation)
  end

  it "Should correctly refetch the X-Wing" do

    query = %Q(
      query XWingRefetchQuery {
        node(id: "U2hpcDox") {
          id
          ... on Ship {
            name
          }
        }
      }
    )

    expectation = {
      data: {
        node: {
          id: 'U2hpcDox',
          name: 'X-Wing'
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, query)

    expect(result).to eql(expectation)
  end

end
