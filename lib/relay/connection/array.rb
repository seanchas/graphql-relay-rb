require 'base64'

module Relay
  module Connection

    ARRAY_CONNECTION_PREFIX = 'arrayconnection'

    Edge            = Struct.new('Edge', :cursor, :node)
    PageInfo        = Struct.new('PageInfo', :startCursor, :endCursor, :hasPreviousPage, :hasNextPage)
    ArrayConnection = Struct.new('ArrayConnection', :edges, :pageInfo)
    EmptyConnection = ArrayConnection.new([], PageInfo.new(nil, nil, false, false))

    def self.connection_from_array(data, args)
      edges   = data.each_with_index.map { |item, i| Edge.new(offset_to_cursor(i), item) }

      start   = [get_offset(args[:after], -1), -1].max + 1
      finish  = [get_offset(args[:before], edges.size + 1), edges.size + 1].min

      edges = edges.slice(start, finish)

      return EmptyConnection if edges.size == 0

      first_preslice_cursor = edges.first[:cursor]
      last_preslice_cursor  = edges.last[:cursor]

      edges = edges.slice(0, args[:first]) unless args[:first].nil?
      egdes = edges.slice!(- args[:last], edges.size) unless args[:last].nil?

      return EmptyConnection if edges.size == 0

      ArrayConnection.new(edges, PageInfo.new(
        edges.first[:cursor],
        edges.last[:cursor],
        edges.first[:cursor]  != first_preslice_cursor,
        edges.last[:cursor]   != last_preslice_cursor
      ))
    end

    def self.offset_to_cursor(index)
      Base64.strict_encode64([ARRAY_CONNECTION_PREFIX, index].join(':'))
    end

    def self.cursor_to_offset(cursor)
      Base64.strict_decode64(cursor).split(':').last.to_i
    end

    def self.get_offset(cursor, default_offset)
      return default_offset unless cursor
      offset = cursor_to_offset(cursor)
      offset.nil? ? default_offset : offset
    end

  end
end
