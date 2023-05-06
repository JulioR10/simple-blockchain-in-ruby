require 'sinatra'
require 'sinatra/json'
require 'json'
require_relative 'blockchain'

set :bind, '0.0.0.0'

# Inicializar la cadena de bloques
launcher

# Obtener toda la cadena de bloques
get '/blocks' do
  json LEDGER
end

post '/blocks' do
  content_type :json

  begin
    new_transactions = JSON.parse(request.body.read)
  rescue JSON::ParserError => e
    halt 400, { message: "Invalid JSON format" }.to_json
  end

  new_block = Block.next(LEDGER.last, new_transactions, STAKEHOLDERS)
  LEDGER << new_block
  new_block.to_json
end
