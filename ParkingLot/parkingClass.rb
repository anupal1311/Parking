class ParkingLot
    @@Current_parked_vehicles = []
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
        puts "*"*30 + " Parking Lot [ Dimensions - #{@rows} X #{@columns} ] " + "*"*30
        @parking_lot_dimensions.each do |rows|
            puts "\n\t\t\t" + rows.map { |columns| columns.to_s }.join("\t")
        end
        puts "\n" + "*"*73
    end

    def validate_user_input(indexes,number,type)
        flag = true
        
        if !((type == "Car" && indexes.length == Car::SPOT_NEEDED) || (type == "Bicycle" && indexes.length == Bicycle::SPOT_NEEDED) || (type == "Bike" && indexes.length == Bike::SPOT_NEEDED) )
            puts "-"*80
            puts "Wrong numbers of spots given"
            puts "-"*80
            flag = false
        end
        
        return flag
    end

    def vehicle_present_in_parking_lot(number)
        flag = false
        @@Current_parked_vehicles.each do |vehicle_detail|
            if(vehicle_detail[:vehicle].vehicle_info[:number] == number)
                flag = true
                break
            end
        end
        return flag
    end

    def update_vehicle_list(number, operation, vehicleObject = nil)
        
        if (operation.upcase == "A")
            vehicle_parking_info = { "vehicle": vehicleObject , "ParkedIn": Time.now , "Location": @actual_positions  }
            @@Current_parked_vehicles.push(vehicle_parking_info)
        elsif (operation.upcase == "R")
            index = 0
            @@Current_parked_vehicles.each_with_index do |vehicle_detail,idx| 
                if (vehicle_detail[:vehicle].vehicle_info[:number] == number)
                    index = idx
                    break
                end
            end
            @@Current_parked_vehicles.delete_at(index)
        end

    end

    def parked_mechanism(type, name, number, indexes)
        vehicleObject = Vehicle.new(type, name, number)
        @given_positions = indexes        
        puts "*"*90
        puts "-"*80
        puts "Let's check user input - "
        puts "-"*80
        if(validate_user_input(indexes,number,type))    
            puts "User Input is Successfully Validated - "
            puts "-"*80
            puts "Let's check the validity of your location - "
            puts "-"*80
            if !(vehicle_present_in_parking_lot(number))
                puts "This is a new Vehicle"
                puts "-"*80
                if(validate_location)
                    puts "Congrats !! Your location is successfully Validated !!\nLet's Check Availability - "
                    puts "-"*80
                    if(check_availability)
                        puts "Congrats !! Space is also available. Let's Park your vehicle -"
                        allocate_space(number)
                        puts "-"*80
                        puts "Your vehicle has successfully parked"
                        update_vehicle_list(number , "A" , vehicleObject)
                        @@Number_of_vehicles_parked[type] = @@Number_of_vehicles_parked[type] + 1
                    else
                        puts "Sorry !! Given location is not available for parking !!"
                        puts "-"*80
                    end
                else
                    puts "Sorry !! Given location is not Valid."
                    puts "-"*80
                end
            else
                puts "vehicle is already present"
                puts "-"*80
            end
        end
        puts "*"*90
    end

    def remove_vehicle_mechaism(type,name,number,indexes)
        puts "*"*40
        puts "-"*80
        puts "Let's Validate User Input - "
        puts "-"*80
        if(validate_user_input(indexes,number,type))
            puts "User Input is Successfully Validated !!"
            puts "-"*80
            puts "Let's check the validity of your location - "
            puts "-"*80
            if(validate_location)
                puts "Congrats !! Your Location is successfully validated !!\nLet's check given vehicle present or not"
                puts "-"*80
                if(vehicle_present_in_parking_lot(number))
                    puts "Congrats !! Your vehicle is present in parking lot !!\nLet's Check Vehicle Parked or not at given location? - "
                    puts "-"*80
                    if(check_parked_vehicle(number))
                        puts "Congrats !! Mentioned vehicle is present at given location. Let's remove your vehicle -"
                        puts "-"*80
                        remove_space
                        puts "Your vehicle has successfully removed."
                        puts "-"*80
                        update_vehicle_list(number,"R")
                        @@Number_of_vehicles_parked[type] = @@Number_of_vehicles_parked[type] - 1
                    end
                else
                    puts "Sorry !! Mentioned vehicle is not parked at given location !!"
                    puts "-"*80
                end
            else
                puts "Sorry !! Given location is not Valid."
                puts "-"*80
            end
        end
        puts "*"*40
    end

    def self.get_number_of_vehicles
        @@Number_of_vehicles_parked
    end

    def to_s
        puts "*"*30 + " Current Parked Vehicles (Dimensions - #{@rows} X #{@columns}) " + "*"*50 +"\n"
        puts "-"*130
        puts "Type\t|\tName\t|\tNumber\t|\tLocation\t\t\t\t\t|\tIn-Time"
        puts "-"*130
        @@Current_parked_vehicles.each do |vehicle_detail|
            puts "#{vehicle_detail[:vehicle].vehicle_info[:type]}\t|\t#{vehicle_detail[:vehicle].vehicle_info[:name]}\t|\t#{vehicle_detail[:vehicle].vehicle_info[:number]}\t|\t#{vehicle_detail[:Location]}\t\t|\t#{vehicle_detail[:ParkedIn]}"
        end
        puts "-"*130
        puts "*"*130 + "\n"
    end
end
