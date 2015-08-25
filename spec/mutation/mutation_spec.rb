require 'relay'
require 'ostruct'

RSpec.describe "Relay mutations" do

  SimpleMutation = Relay.mutationWithCliendMutationId do
    name 'SimpleMutation'
    outputField :result, GraphQL::GraphQLInt
    mutateAndGetPayload lambda { |input, context|
      OpenStruct.new(result: 1)
    }
  end

  SimpleFutureMutation = Relay.mutationWithCliendMutationId do
    name 'SimpleFutureMutation'
    outputField :result, GraphQL::GraphQLInt
    mutateAndGetPayload lambda { |input, context|
      GraphQL::Execution::Pool.future do
        { result: 1 }
      end
    }
  end

  Mutation = GraphQL::GraphQLObjectType.new do
    name 'Mutation'

    field SimpleMutation
    field SimpleFutureMutation
  end

  MutationSchema = GraphQL::GraphQLSchema.new do
    name 'Schema'
    query     Mutation
    mutation  Mutation
  end


  it "Should return same client mutation id" do
    query = %q(
      mutation M {
        SimpleMutation(input: { clientMutationId: "abc" }) {
          result
          clientMutationId
        }
      }
    )

    expect(GraphQL::graphql(MutationSchema, query)[:data][:SimpleMutation][:clientMutationId]).to eql('abc')
  end


  it "Should introspect input" do
    query = %q({
      __type(name: "SimpleMutationInput") {
        name
        kind
        inputFields {
          name
          type {
            name
            kind
            ofType {
              name
              kind
            }
          }
        }
      }
    })

    expectation = {
      data: {
        __type: {
          name: "SimpleMutationInput",
          kind: "INPUT_OBJECT",
          inputFields: [{
            name: "clientMutationId",
            type: {
              name: nil,
              kind: "NON_NULL",
              ofType: {
                name: "String",
                kind: "SCALAR"
              }
            }
          }]
        }
      }
    }

    expect(GraphQL::graphql(MutationSchema, query)).to eql(expectation)
  end

  it "Should introspect payload" do
    query = %q({
      __type(name: "SimpleMutationPayload") {
        name
        kind
        fields {
          name
          type {
            name
            kind
            ofType {
              name
              kind
            }
          }
        }
      }
    })

    expectation = {
      data: {
        __type: {
          name: "SimpleMutationPayload",
          kind: "OBJECT",
          fields: [{
            name: "result",
            type: {
              name: "Int",
              kind: "SCALAR",
              ofType: nil
            }
          }, {
            name: "clientMutationId",
            type: {
              name: nil,
              kind: "NON_NULL",
              ofType: {
                name: "String",
                kind: "SCALAR"
              }
            }
          }]
        }
      }
    }

    expect(GraphQL::graphql(MutationSchema, query)).to eql(expectation)
  end

  it "Should introspect field" do
    query = %q({
      __schema {
        mutationType {
          fields {
            name
            args {
              name
              type {
                name
                kind
                ofType {
                  name
                  kind
                }
              }
            }
            type {
              name
              kind
            }
          }
        }
      }
    })

    expectation = {
      :data => {
        :__schema => {
          :mutationType => {
            :fields => [{
              :name => "SimpleMutation",
              :args => [{
                :name => "input",
                :type => {
                  :name => nil,
                  :kind => "NON_NULL",
                  :ofType => {
                    :name => "SimpleMutationInput",
                    :kind => "INPUT_OBJECT"
                  }
                }
              }],
              :type => {
                :name => "SimpleMutationPayload",
                :kind => "OBJECT"
              }
            }, {
              :name => "SimpleFutureMutation",
              :args => [{
                :name => "input",
                :type => {
                  :name => nil,
                  :kind => "NON_NULL",
                  :ofType => {
                    :name => "SimpleFutureMutationInput",
                    :kind => "INPUT_OBJECT"
                  }
                }
              }],
              :type => {
                :name => "SimpleFutureMutationPayload",
                :kind => "OBJECT"
              }
            }]
          }
        }
      }
    }

    expect(GraphQL::graphql(MutationSchema, query)).to eql(expectation)
  end

end
