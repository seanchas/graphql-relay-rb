require 'relay'
require_relative 'data'

RSpec.describe 'Relay Node' do

  def schema
    Relay::Node::Data::Schema
  end

  def user_q1
    %Q{{
      node(id: "1") {
        id
      }
    }}
  end

  def user_q2
    %Q{{
      node(id: "1") {
        id
        ... on User {
          name
        }
      }
    }}
  end

  def user_q3
    %Q{{
      node(id: "1") {
        id
        ... on Photo {
          width
        }
      }
    }}
  end

  def photo_q1
    %Q{{
      node(id: "4") {
        id
      }
    }}
  end

  def photo_q2
    %Q{{
      node(id: "4") {
        id
        ... on Photo {
          width
        }
      }
    }}
  end

  def common_q1
    %Q{{
      node(id: "5") {
        id
      }
    }}
  end

  it 'Should get correct id for users' do
    expectation   = { data: { node: { id: '1' }} }
    result        = GraphQL::graphql(schema, user_q1)
    expect(result).to eq(expectation)
  end

  it 'Should get correct id for photos' do
    expectation   = { data: { node: { id: '4' }} }
    result        = GraphQL::graphql(schema, photo_q1)
    expect(result).to eq(expectation)
  end

  it 'Should get correct name for users' do
    expectation   = { data: { node: { id: '1', name: 'John Doe' }} }
    result        = GraphQL::graphql(schema, user_q2)
    expect(result).to eq(expectation)
  end

  it 'Should get correct width for photos' do
    expectation = { data: { node: { id: '4', width: 400 }}}
    result      = GraphQL::graphql(schema, photo_q2)
    expect(result).to eq(expectation)
  end

  it 'Should ignore photo fragment on user' do
    expectation = { data: { node: { id: '1' }}}
    result      = GraphQL::graphql(schema, user_q3)
    expect(result).to eq(expectation)
  end

  it 'Should return null for bad IDs' do
    expectation = { data: { node: nil } }
    result      = GraphQL::graphql(schema, common_q1)
    expect(result).to eq(expectation)
  end
end
