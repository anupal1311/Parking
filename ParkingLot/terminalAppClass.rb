class TerminalApp
    attr_accessor :application_name

    def initialize(application_name)
        @application_name = application_name
    end

    def run_application
        if @application_name == "Vehicle Parking Application"
            puts "Welcome to Parking Lot !! Please specify the parking lot dimension as Length Width !!"
            rows,columns = gets.chomp.split(" ").map{|x| x.to_i }

            parkingLotObject = ParkingLot.new(rows,columns)
            user_yes_no = "Y"

            while(user_yes_no == "Y") do 
                puts "Please select which operation you want to perform 
                    1. Park a vehicle
                    2. Remove a vehicle
                    3. Display parking Lot
                    4. Display current parked vehicles
                    5. Display Count of Each Category Vehicle "
                            
                user_selection = gets.chomp.to_i

                if ([1,2].include? user_selection)
                    puts "Please Specify Space Separated Vehicle type, Name and 4-Digit Number "
                    type,name,number = gets.chomp.split(" ")
                    puts "Please Specify Location/indexes -"
                    indexes = gets.chomp.split(" ").map {|x| x.to_i - 1}
                end

                case user_selection
                when 1
                    parkingLotObject.parked_mechanism(type,name,number,indexes)
                when 2
                    parkingLotObject.remove_vehicle_mechaism(type,name,number,indexes)
                when 3
                    parkingLotObject.display_parkingLot
                when 4
                    parkingLotObject.to_s
                when 5
                    current_vehicle_count = ParkingLot.get_number_of_vehicles
                    puts "*"*80
                    puts "\t\t Count of Each Category Vechicles"
                    puts "*"*80
                    puts "Bicycles - #{current_vehicle_count['Bicycle']}\nBikes - #{current_vehicle_count['Bike']}\nCars - #{current_vehicle_count['Car']}"
                else
                    puts "Please select any option from the above only !!"
                end

                puts "-"*80
                puts "Want to perform more operation ? [y/n]"
                puts "-"*80
                user_yes_no = gets.chomp.upcase
            end
        end
    end
end