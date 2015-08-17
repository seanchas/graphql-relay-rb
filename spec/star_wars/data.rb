module StarWars
  module Data

    Ship    = Struct.new('Ship', :id, :name)
    Faction = Struct.new('Faction', :id, :name, :ships)

    XWing   = Ship.new(1, 'X-Wing')
    YWing   = Ship.new(2, 'Y-Wing')
    AWing   = Ship.new(3, 'A-Wing')
    Falcon  = Ship.new(4, 'Millenium Falcon')
    HomeOne = Ship.new(5, 'Home One')

    TieFighter      = Ship.new(6, 'Tie Fighter')
    TieInterceptor  = Ship.new(7, 'Tie Interceptor')
    Executor        = Ship.new(8, 'Executor')

    Rebels  = Faction.new(1, 'Alliance to Restore the Republic',  [1, 2, 3, 4, 5])
    Empire  = Faction.new(2, 'Galactic Empire',                   [6, 7, 8])

    Data = {
      faction: {
        1 => Rebels,
        2 => Empire
      },
      ship: {
        1 => XWing,
        2 => YWing,
        3 => AWing,
        4 => Falcon,
        5 => HomeOne,
        6 => TieFighter,
        7 => TieInterceptor,
        8 => Executor
      }
    }

    def self.ship(id)
      Data[:ship][id]
    end

    def self.faction(id)
      Data[:faction][id]
    end

    def self.rebels
      Rebels
    end

    def self.empire
      Empire
    end

  end
end
