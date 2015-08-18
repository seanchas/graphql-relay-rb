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
    expectations = {all: [{id: 'VXNlcjox'}, {id: 'VXNlcjoy'}, {id: 'UGhvdG86Mw=='}, {id: 'UGhvdG86NA=='}]}
    document = GraphQL::Language.parse(all_q1)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(expectations)
  end

  it "Should refetch ids" do
    expectations = {user: {id: 'VXNlcjox', name: 'John Doe'}, photo: {id: 'UGhvdG86Mw==', width: 300}}
    document = GraphQL::Language.parse(all_q2)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(expectations)
  end

end
