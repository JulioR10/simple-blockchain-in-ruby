class Block
  attr_reader :index, :timestamp, :transactions, 
							:transactions_count, :previous_hash, 
							:nonce, :hash 

  def initialize(index, transactions, previous_hash, stakeholders)
    @index               = index
    @timestamp           = Time.now
    @transactions        = transactions
    @transactions_count  = transactions.size
    @previous_hash       = previous_hash
    @stakeholder, @hash  = compute_hash_with_proof_of_stake(stakeholders)
  end

	def compute_hash_with_proof_of_stake(stakeholders)
    selected_stakeholder = select_stakeholder(stakeholders)
    sha = Digest::SHA256.new
    sha.update(selected_stakeholder.to_s + @index.to_s + @timestamp.to_s + @transactions.to_s + @transactions_count.to_s + @previous_hash)
    hash = sha.hexdigest
    [selected_stakeholder, hash]
  end
  
  def select_stakeholder(stakeholders)
    total_stake = stakeholders.values.inject(:+)
    stake_target = rand(total_stake)
    
    running_total = 0
    stakeholders.each do |address, stake|
      running_total += stake
      return address if running_total > stake_target
    end
  end
	
  def calc_hash_with_nonce(nonce=0)
    sha = Digest::SHA256.new
    sha.update( nonce.to_s + 
								@index.to_s + 
								@timestamp.to_s + 
								@transactions.to_s + 
								@transactions_count.to_s +	
								@previous_hash )
    sha.hexdigest 
  end

  def self.first(stakeholders, *transactions)    # Create genesis block
    ## Uses index zero (0) and arbitrary previous_hash ("0")
    Block.new(0, transactions, "0", stakeholders)
  end

  def self.next(previous, transactions, stakeholders)
    Block.new(previous.index + 1, transactions, previous.hash, stakeholders)
  end

  def to_json(*_args)
    {
      'index' => @index,
      'timestamp' => @timestamp,
      'transactions' => @transactions,
      'transactions_count' => @transactions_count,
      'previous_hash' => @previous_hash,
      'stakeholder' => @stakeholder,
      'hash' => @hash
    }.to_json
  end
  
end  # class Block