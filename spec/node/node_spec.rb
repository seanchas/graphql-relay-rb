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
    user_expect = {'node' => { 'id' => '1' }}
    document = GraphQL::Language.parse(user_q1)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(user_expect)
  end

  it 'Should get correct id for photos' do
    photo_expect = {'node' => { 'id' => '4' }}
    document = GraphQL::Language.parse(photo_q1)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(photo_expect)
  end

  it 'Should get correct name for users' do
    user_expect = {'node' => { 'id' => '1', 'name' => 'John Doe' }}
    document = GraphQL::Language.parse(user_q2)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(user_expect)
  end

  it 'Should get correct width for photos' do
    photo_expect = {'node' => { 'id' => '4', 'width' => 400 }}
    document = GraphQL::Language.parse(photo_q2)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(photo_expect)
  end

  it 'Should ignore photo fragment on user' do
    user_expect = {'node' => { 'id' => '1' }}
    document = GraphQL::Language.parse(user_q3)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(user_expect)
  end

  it 'Should return null for bad IDs' do
    nil_expect = {'node' => nil}
    document = GraphQL::Language.parse(common_q1)
    executor = GraphQL::Executor.new(document, schema)
    expect(executor.execute({})).to eq(nil_expect)
  end
end
