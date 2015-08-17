require 'graphql'
require 'base64'
require_relative 'node/plural'

module Relay

  module Node

    def self.definitions(fetcher, resolver)

      interface = GraphQL::GraphQLInterfaceType.new do
        name          'Node'
        description   'An object with ID'

        field         :id, ! GraphQL::GraphQLID do
          description 'The id of the object'
        end

        resolve_type resolver
      end

      field = GraphQL::GraphQLField.new do
        name          'node'
        description   'Fetches an object given its ID'
        type          interface

        arg :id, ! GraphQL::GraphQLID do
          description 'The ID of an object'
        end

        resolve lambda { |root, params, info, *args|
          fetcher.call(params[:id], info)
        }
      end

      { interface: interface, field: field }
    end

    def self.to_global_id(type, id)
      Base64.strict_encode64([type, id].join(':'))
    end

    def self.from_global_id(global_id)
      type, id = Base64.strict_decode64(global_id).split(':')
      {
        type: type,
        id: id
      }
    end


    class GlobalIDFieldConfiguration < GraphQL::GraphQLFieldConfiguration
      slot :type_name, String
      slot :resolve_id, Proc
    end

    class GlobalIDField < GraphQL::GraphQLField
      configure_with GlobalIDFieldConfiguration
    end

    class GraphQL::GraphQLObjectTypeConfiguration

      def global_id_field(*args, &block)
        configuration = GlobalIDField.new(*args) do
          type GraphQL::GraphQLID
          resolve lambda { |object|
            Relay::Node.to_global_id(type_name, resolve_id.nil? ? object.id : resolve_id.call(object))
          }
        end
        configuration.instance_eval(&block) if block_given?
        field(configuration)
      end

    end

  end

end
