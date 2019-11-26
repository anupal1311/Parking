class ParkingLot
    attr_accessor :rows, :columns , :parking_lot_dimensions, :givenPositions, :actualPositions
    def initialize(rows,columns)
        @rows = rows
        @columns = columns
        @parking_lot_dimensions = Array.new(rows) { Array.new(columns, 0) }
        @givenPositions = []
        @actualPositions = []
    end

    def check_incremental_array(step, array)
        flag = true
        if (array.length > 1)
            sortedArray = array.sort
            lastNumber = sortedArray[0]
            sortedArray[1, sortedArray.length - 1].each do |num|
                if lastNumber + step != num
                    flag = false
                    break
                end
                lastNumber = num
            end
            flag = true
        end        
        return flag
    end

    def validateLocation
        flag = false
        allSpots = @givenPositions.map { |ele| [ ele/@columns , ele% @columns ] }
        allRows = allSpots.map {|ele| ele[0]}
        allColumns = allSpots.map {|ele| ele[1]}
        
        validRow = allRows.any?{ |ele| ele < @rows}
        if validRow
            if((allRows.uniq.length == 1 && check_incremental_array(1,allColumns)) || (allColumns.uniq.length == 1 && check_incremental_array(1,allRows)) || (allRows.uniq.length == allColumns.uniq.length && check_incremental_array(1,allRows.uniq) && check_incremental_array(1,allColumns.uniq) ) )
                flag = true
                @actualPositions = allSpots
            end
        end
        return flag
    end

    def checkAvailability
        return @actualPositions.all? {|ele| @parking_lot_dimensions[ele[0]][ele[1]] == 0} ? true : false
    end

    def allocateSpace(value)
        @actualPositions.each do |ele|
            @parking_lot_dimensions[ele[0]][ele[1]] = value
        end
    end

end

class Vehicle
    @@Number_of_Vehicles = 0
    attr_accessor :required_space, :vehicle_type

    def initialize(spot_needed,vehicle_type)
        @@Number_of_Vehicles += 1
        @required_space = spot_needed
        @vehicle_type = vehicle_type
    end

    def parkedMechanism(parkingObject)

        puts "Let's check the validity of your location - "
        if(parkingObject.validateLocation)
            puts "Congrats !! Your location is successfully Validated !!\nLet's Check Availability - "
            if(parkingObject.checkAvailability)
                puts "Congrats !! Space is also available. Let's Park your vehicle -"
                parkingObject.allocateSpace(@vehicle_type)
                puts "Your vehicle successfully parked"
            else
                puts "Sorry !! Given location is not available for parking !!"
            end
        else
            puts "Sorry !! Given location is not Valid."
        end
    end

end

class Bicycle < Vehicle
    @@bicycleParked = 0
    def initialize(spot_needed,vehicle_type)
        @@bicycleParked += 1
        super
    end
end

class Bike < Vehicle
    @@bikeParked = 0
    def initialize(spot_needed,vehicle_type)
        @@bikeParked += 1
        super
    end
end

class Car < Vehicle
    @@carsParked = 0
    def initialize(spot_needed,vehicle_type)
        @@carsParked += 1
        super
    end
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

    userSelection = gets.chomp.to_i

    case userSelection
    when 1
        vehicle = Bicycle.new(1,"Bicycle")
    when 2
        vehicle = Bike.new(2,"Bike")
    when 3
        vehicle = Car.new(3,"Car")
    when 4

    when 5

    when 6
        puts vehicle.bicycleParked
    when 7
        puts vehicle.bikeParked
    when 8
        puts vehicle.carsParked
    when 9
        # needs tp done
    when 10
        # NEEDS TO be done
    when 11
        # needs to be done
    else
        puts "Please select any option from the above only !!"

    indexes = gets.chomp.split(" ").map {|x| x.to_i}
    parkingLotObject.givenPositions = indexes

    carObj = Car.new(2,"Car")
    carObj.parkedMechanism(parkingLotObject)

    puts "Want to perform more operation ? [y/n]"
    user_yes_no = gets.chomp.upcase
end