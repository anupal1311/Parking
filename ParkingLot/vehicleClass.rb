class Vehicle
    attr_accessor :vehicle_info

    def initialize(vehicle_type,name,number)
        @vehicle_info = {}
        @vehicle_info[:type] = vehicle_type
        @vehicle_info[:name] = name
        @vehicle_info[:number] = number
    end

end

class Bicycle < Vehicle
    SPOT_NEEDED = 1
end

class Bike < Vehicle
    SPOT_NEEDED = 2
end

class Car < Vehicle
    SPOT_NEEDED = 4
end