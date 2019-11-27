class ParkingLot
    @@Number_of_vehicles_parked = { "Car" => 0 , "Bike" => 0 , "Bicycle" => 0 }

    attr_accessor :rows, :columns , :parking_lot_dimensions, :given_positions, :actual_positions
    def initialize(rows,columns)
        @rows = rows
        @columns = columns
        @parking_lot_dimensions = Array.new(rows) { Array.new(columns, 0) }
        @given_positions = []
        @actual_positions = []
    end

    def check_incremental_array(step, array)
        flag = true
        if (array.length > 1)
            sorted_array = array.sort
            last_number = sorted_array[0]
            sorted_array[1, sorted_array.length - 1].each do |num|
                if last_number + step != num
                    flag = false
                    break
                end
                last_number = num
            end
            flag = true
        end        
        return flag
    end

    def validate_location
        flag = false
        all_spots = @given_positions.map { |ele| [ ele/@columns , ele% @columns ] }
        all_rows = all_spots.map {|ele| ele[0]}
        all_columns = all_spots.map {|ele| ele[1]}
        
        valid_row = all_rows.any?{ |ele| ele < @rows}
        if valid_row
            if((all_rows.uniq.length == 1 && check_incremental_array(1,all_columns)) || (all_columns.uniq.length == 1 && check_incremental_array(1,all_rows)) || (all_rows.uniq.length == all_columns.uniq.length && check_incremental_array(1,all_rows.uniq) && check_incremental_array(1,all_columns.uniq) ) )
                flag = true
                @actual_positions = all_spots
            end
        end
        return flag
    end

    def check_availability
        return @actual_positions.all? {|ele| @parking_lot_dimensions[ele[0]][ele[1]] == 0} ? true : false
    end

    def allocate_space(value)
        @actual_positions.each do |ele|
            @parking_lot_dimensions[ele[0]][ele[1]] = value
        end
    end

    def remove_space
        @actual_positions.each do |ele|
            @parking_lot_dimensions[ele[0]][ele[1]] = 0
        end
    end

    def check_parked_vehicle(value)
        return @actual_positions.all? {|ele| @parking_lot_dimensions[ele[0]][ele[1]] == value} ? true : false
    end

    def display_parkingLot
        puts "*"*30 + " Parking Lot " + "*"*30
        @parking_lot_dimensions.each do |rows|
            puts "\n\t\t\t" + rows.map { |columns| columns.to_s }.join("\t")
        end
        puts "\n" + "*"*73
    end

    def parked_mechanism(vehicleObject)
        puts "*"*40
        puts "Let's check the validity of your location - "
        if(validate_location)
            puts "Congrats !! Your location is successfully Validated !!\nLet's Check Availability - "
            if(check_availability)
                puts "Congrats !! Space is also available. Let's Park your vehicle -"
                allocate_space(vehicleObject.vehicle_type)
                puts "Your vehicle has successfully parked"
                @@Number_of_vehicles_parked[vehicleObject.vehicle_type] = @@Number_of_vehicles_parked[vehicleObject.vehicle_type] + 1
            else
                puts "Sorry !! Given location is not available for parking !!"
            end
        else
            puts "Sorry !! Given location is not Valid."
        end
        puts "*"*40
    end

    def remove_vehicle_mechaism(vehicleObject)
        puts "*"*40
        puts "Let's check the validity of your location - "
        if(validate_location)
            puts "Congrats !! Your location is successfully Validated !!\nLet's Check Vehicle Parked or not? - "
            if(check_parked_vehicle(vehicleObject.vehicle_type))
                puts "Congrats !! Mentioned vehicle is present at given location. Let's remove your vehicle -"
                remove_space
                puts "Your vehicle has successfully removed."
                @@Number_of_vehicles_parked[vehicleObject.vehicle_type] = @@Number_of_vehicles_parked[vehicleObject.vehicle_type] - 1
            else
                puts "Sorry !! Mentioned vehicle is not parked at given location !!"
            end
        else
            puts "Sorry !! Given location is not Valid."
        end
        puts "*"*40
    end

end

class Vehicle
    attr_accessor :vehicle_type

    def initialize(vehicle_type)
        @vehicle_type = vehicle_type
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

puts "Welcome to Parking Lot !! Please specify the parking lot dimension as Length Width !!"
rows,columns = gets.chomp.split(" ").map{|x| x.to_i }

parkingLotObject = ParkingLot.new(rows,columns)
user_yes_no = "Y"

while(user_yes_no == "Y") do 
    puts "Please select which operation you want to perform 
        1. Park a Bicycle (1 spot)
        2. Park a Bike (2 spots)
        3. Park a Car (4 spots)
        4. Display empty number of spots
        5. Display occupied number of spots
        6. Number of Bicycles parked
        7. Number of Bikes parked
        8. Number of Cars parked
        9. Remove a Bicycle
        10. Remove a Bike
        11. Remove a Car"

    user_selection = gets.chomp.to_i

    if (!([4,5,6,7,8].include? user_selection) && (Array(1..11).include? user_selection )) 
        puts "Please Specify Indexes/Location"
        indexes = gets.chomp.split(" ").map {|x| x.to_i - 1}
        parkingLotObject.given_positions = indexes
    end
    
    case user_selection
    when 1
        vehicle = Bicycle.new("Bicycle")
        parkingLotObject.parked_mechanism(vehicle)
    when 2
        vehicle = Bike.new("Bike")
        parkingLotObject.parked_mechanism(vehicle)
    when 3
        vehicle = Car.new("Car")
        parkingLotObject.parked_mechanism(vehicle)
    when 4
        parkingLotObject.display_parkingLot
    when 5
        parkingLotObject.display_parkingLot
    when 6
        puts ParkingLot.Number_of_vehicles_parked[:Bicycle]
    when 7
        puts ParkingLot.Number_of_vehicles_parked[:Bicycle]
    when 8
        puts ParkingLot.Number_of_vehicles_parked[:Bicycle]
    when 9
        vehicle = Bicycle.new("Bicycle")
        parkingLotObject.remove_vehicle_mechaism(vehicle)
    when 10
        vehicle = Bike.new("Bike")
        parkingLotObject.remove_vehicle_mechaism(vehicle)
    when 11
        vehicle = Car.new("Car")
        parkingLotObject.remove_vehicle_mechaism(vehicle)
    else
        puts "Please select any option from the above only !!"
    end

    puts "Want to perform more operation ? [y/n]"
    user_yes_no = gets.chomp.upcase
end