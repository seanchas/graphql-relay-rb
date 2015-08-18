require_relative 'data'
require_relative 'schema'

RSpec.describe "Star Wars connection" do

  it "Should correctly fetch first ship of the rebels" do
    query = %Q(
      query RebelShipQuery {
        rebels {
          name
          ships(first: 1) {
            edges {
              node {
                name
              }
            }
          }
        }
      }
    )

    expectation = {
      rebels: {
        name: 'Alliance to Restore the Republic',
        ships: {
          edges: [
            {
              node: {
                name: 'X-Wing'
              }
            }
          ]
        }
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
  end

  it "Should correctly fetch first 2 ships of the rebels with a cursor" do
    query = %Q(
      query RebelShipQuery {
        rebels {
          name
          ships(first: 2) {
            edges {
              cursor
              node {
                name
              }
            }
          }
        }
      }
    )

    expectation = {
      rebels: {
        name: 'Alliance to Restore the Republic',
        ships: {
          edges: [
            {
              cursor: 'YXJyYXljb25uZWN0aW9uOjA=',
              node: {
                name: 'X-Wing'
              }
            },
            {
              cursor: 'YXJyYXljb25uZWN0aW9uOjE=',
              node: {
                name: 'Y-Wing'
              }
            }
          ]
        }
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
  end

  it "Should correctly fetch next 3 ships of the rebels with a cursor" do
    query = %Q(
      query RebelShipQuery {
        rebels {
          name
          ships(first: 3, after: "YXJyYXljb25uZWN0aW9uOjE=") {
            edges {
              cursor
              node {
                name
              }
            }
          }
        }
      }
    )

    expectation = {
      rebels: {
        name: 'Alliance to Restore the Republic',
        ships: {
          edges: [
            {
              cursor: 'YXJyYXljb25uZWN0aW9uOjI=',
              node: {
                name: 'A-Wing'
              }
            }, {
              cursor: 'YXJyYXljb25uZWN0aW9uOjM=',
              node: {
                name: 'Millenium Falcon'
              }
            }, {
              cursor: 'YXJyYXljb25uZWN0aW9uOjQ=',
              node: {
                name: 'Home One'
              }
            }
          ]
        }
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
  end

  it "Should correctly fetch no ships at the end of the connection" do
    query = %Q(
      query RebelShipQuery {
        rebels {
          name
          ships(first: 3, after: "YXJyYXljb25uZWN0aW9uOjQ=") {
            edges {
              cursor
              node {
                name
              }
            }
          }
        }
      }
    )

    expectation = {
      rebels: {
        name: 'Alliance to Restore the Republic',
        ships: {
          edges: []
        }
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
  end


  it "Should correctly identify the end of the list" do
    query = %Q(
      query RebelShipQuery {
        rebels {
          name
          originalShips: ships(first: 2) {
            edges {
              node {
                name
              }
            }
            pageInfo {
              hasNextPage
            }
          }
          moreShips: ships(first: 3, after: "YXJyYXljb25uZWN0aW9uOjE=") {
            edges {
              node {
                name
              }
            }
            pageInfo {
              hasNextPage
            }
          }
        }
      }
    )

    expectation = {
      rebels: {
        name:'Alliance to Restore the Republic',
        originalShips: {
          edges: [
            {
              node: {
                name: 'X-Wing'
              }
            }, {
              node: {
                name: 'Y-Wing'
              }
            }
          ],
          pageInfo: {
            hasNextPage: true
          }
        },
        moreShips: {
          edges: [
            {
              node: {
                name: 'A-Wing'
              }
            }, {
              node: {
                name: 'Millenium Falcon'
              }
            },{
              node: {
                name: 'Home One'
              }
            }
          ],
          pageInfo: {
            hasNextPage: false
          }
        }
      }
    }

    document = GraphQL::Language.parse(query)
    executor = GraphQL::Executor.new(document, StarWars::Schema)

    expect(executor.execute({})).to eql(expectation)
  end
end
