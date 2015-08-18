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
      rebels: {
        id: 'RmFjdGlvbjox',
        name: 'Alliance to Restore the Republic'
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
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
      node: {
        id: 'RmFjdGlvbjox',
        name: 'Alliance to Restore the Republic'
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
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
      empire: {
        id: 'RmFjdGlvbjoy',
        name: 'Galactic Empire'
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
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
      node: {
        id: 'RmFjdGlvbjoy',
        name: 'Galactic Empire'
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
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
      node: {
        id: 'U2hpcDox',
        name: 'X-Wing'
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
  end

end
