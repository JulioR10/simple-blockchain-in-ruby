require 'digest'    							# For hash checksum digest function SHA256
require 'pp'        							# For pp => pretty printer
require_relative 'block'					# class Block
require_relative 'transaction'		# method Transactions

# TRANSACTIONS = []

LEDGER = []

STAKEHOLDERS = {
	"Alice" => 50,
	"Bob" => 100,
	"Carol" => 200,
	"Dave" => 150
}

def create_first_block
	i = 0
	instance_variable_set("@b#{i}", Block.first(STAKEHOLDERS, 
		{ from: "Dutchgrown", to: "Vincent", what: "Tulip Bloemendaal Sunset", qty: 10 },
		{ from: "Keukenhof", to: "Anne", what: "Tulip Semper Augustus", qty: 7 }
	))
	LEDGER << @b0
	pp @b0
	p "============================"
	#add_block
end
	
def add_block
	i = 1
	loop do
	  instance_variable_set("@b#{i}", Block.next(instance_variable_get("@b#{i-1}"), get_transactions_data, STAKEHOLDERS))
	  LEDGER << instance_variable_get("@b#{i}")
	  p "============================"
	  pp instance_variable_get("@b#{i}")
	  p "============================"
	  i += 1
	end
end

def launcher
	puts "==========================="
	puts ""
	puts "Welcome to Simple Blockchain In Ruby !"
	puts ""
	sleep 1.5
	puts "This program was created by Anthony Amar for and educationnal purpose"
	puts ""
	sleep 1.5
	puts "Wait for the genesis (the first block of the blockchain)"
	puts ""
	for i in 1..10
		print "."
		sleep 0.5
		break if i == 10
	end
	puts "" 
	puts "" 
	puts "==========================="
	create_first_block
end


# launcher