require 'relay'
require_relative 'data_global'

RSpec.describe 'Relay Node with Global ID' do

  def schema
    Relay::Node::DataGlobal::Schema
  end

  def all_q1
    %Q{{
      all {
        id
      }
    }}
  end

  def all_q2
    %Q{{
      user: node(id: "VXNlcjox") {
        id
        ... on User {
          name
        }
      }
      photo: node(id: "UGhvdG86Mw==") {
        id
        ... on Photo {
          width
        }
      }
    }}
  end


  it "Should give different ids" do
    expectation   = { data: {all: [{id: 'VXNlcjox'}, {id: 'VXNlcjoy'}, {id: 'UGhvdG86Mw=='}, {id: 'UGhvdG86NA=='}]} }
    result        = GraphQL::graphql(schema, all_q1)
    expect(result).to eq(expectation)
  end

  it "Should refetch ids" do
    expectation   = { data: {user: {id: 'VXNlcjox', name: 'John Doe'}, photo: {id: 'UGhvdG86Mw==', width: 300}} }
    result        = GraphQL::graphql(schema, all_q2)
    expect(result).to eq(expectation)
  end

end
