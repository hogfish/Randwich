require 'yaml'

def get_fillings
	config = YAML.load_file('sandwich_fillings.yaml')
	fillingsList = config["fillings"]
	fillings = []
	randNumbers = []

	(1..(rand(6)+1)).each do |i|
		randNum = rand(fillingsList.length)
		#Make sure we don't have the same filling twice
		while randNumbers.include?(randNum) do
			randNum = rand(fillingsList.length)
		end
		randNumbers << randNum
		fillings << fillingsList[randNum]
	end
	
	fillingsList = fillings.join(", ")

	fillingsList
end

config = YAML.load_file('sandwich_fillings.yaml')
#Load the sandwich suppression list
supp = YAML.load_file('sandwichSuppressionList.yaml')
suppList = supp["badSandwiches"]

foundSandwich = false
while foundSandwich == false do
	
	#Get bread
	breadList = config["bread"]
	bread = breadList[rand(breadList.length)]
	
	#Get fillings
	fillings = get_fillings
	#Check the sandwich suppression list
	if suppList != nil
		while suppList.include?(fillings) do
			fillings = get_fillings
		end
	end
	
	#Output the sandwich
	sandwich = "Your sandwich: #{fillings} on #{bread}"
	`echo #{sandwich} | clip`
	puts sandwich
	
	#Make sure it's edible
	puts "You gonna eat that? Y/N"
	STDOUT.flush
	edible = gets.chomp
	
	#If it's not edible, add to suppression list
	if (edible == "n" || edible == "N")
		File.open("sandwichSuppressionList.yaml", 'a') {|f| f.puts "- #{fillings}" }
		get_fillings
	else
		foundSandwich = true
	end
end