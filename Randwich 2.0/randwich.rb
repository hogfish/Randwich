require 'yaml'

def formatList(list)
	newList = []
	(0..(list.length)).each do |i|
		if (list[i] != nil)
			newList << list[i]
		end
	end
	newList.join(", ").capitalize
end

def get_fillings
	fillings = []
	#Don't return an empty sandwich
	while (fillings.length == 0) do
		#get meats - you can either have fish, meat or poultry, with a chance of getting a combo of meat and poultry
		if(rand(2) == 1)
			fillings << get_ingredient("fish")
		else
			fillings << get_ingredient("meat")
			fillings << get_ingredient("poultry")
		end
		#get cheese
		fillings << get_ingredient("cheese")
		#get salads
		fillings << get_salads
		#get leaves
		fillings << get_ingredient("leaves")
		#get condiments
		fillings << get_ingredient("condiments")
	end
	fillingsList = formatList(fillings)
end

def get_ingredient(fillingType)
	#50/50 chance of getting a random filling, or nothing at all
	config = YAML.load_file('sandwich_fillings.yaml')
	fillingsList = config[fillingType]
	if (rand(2) == 1)
		ingredient = fillingsList[rand(fillingsList.length)]
	else
		ingredient = nil
	end
end

def get_salads
	config = YAML.load_file('sandwich_fillings.yaml')
	fillingsList = config["salads"]
	fillings = []
	randNumbers = []
	#One in 10 chance of getting no salads at all
	if (rand(10) != 1)
		#chance of multiple salads
		(0..(rand(4))).each do |i|
			randNum = rand(fillingsList.length)
			#Make sure we don't have the same filling twice
			while randNumbers.include?(randNum) do
				randNum = rand(fillingsList.length)
			end
			randNumbers << randNum
			fillings << fillingsList[randNum]
		end
		fillings
	else
		#chance of no salads
		ingredient = nil
	end
end


config = YAML.load_file('sandwich_fillings.yaml')
#Load the sandwich suppression list
supp = YAML.load_file('sandwichSuppressionList.yaml')
suppList = supp["badSandwiches"]

foundSandwich = false
puts "The following randwich has been copied to clipboard:"
useExtremeFillings = ARGV[0] == "xt"
while foundSandwich == false do
	
	#Get bread
	breadList = config["bread"]
	bread = breadList[rand(breadList.length)]

	fillings = get_fillings
	
	#Check the sandwich suppression list
	if suppList != nil
		while suppList.include?(fillings) do
			fillings = get_fillings
		end
	end
	
	#Output the sandwich
	sandwich = "#{fillings} on #{bread}"
	`echo #{sandwich} | clip`
	puts "#{sandwich}"
	
	#Make sure it's edible
	puts "How's that?\n(1=Try again | 2=Add to suppression list | 3=Quit)"
	STDOUT.flush
	input = gets.chomp
	
	#If it's not edible, add to suppression list
	case (input)
		when "1"
		puts "How about..."
		get_fillings
		when "2"
		File.open("sandwichSuppressionList.yaml", 'a') {|f| f.puts "- #{fillings}" }
		puts "Randwich added to suppression list. What about..."
		get_fillings
	else
		foundSandwich = true
	end
end