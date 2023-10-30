# app/services/client_service.rb

require 'json'

# The ClientService class provides functionalities to interact with a JSON-based
# client dataset. It supports searching by client name and finding clients with duplicate emails.
#
# Example:
#   service = ClientService.new("path/to/your/client.json")
#   results = service.search_by_name('John')
#   duplicates = service.find_duplicates_by_email
#
class ClientService
  attr_accessor :clients

  # Initializes a new ClientService object.
  #
  # @param [String] file_path the path to the JSON file containing client information.
  def initialize(data_or_path)
    @clients = if data_or_path.strip.start_with?('{', '[')
                 JSON.parse(data_or_path)
               else
                 JSON.parse(File.read(data_or_path))
               end

  rescue Errno::ENOENT, JSON::ParserError => e
    puts "An error occurred: #{e.message}"
    @clients = []
  end

  # Search for clients by their full name.
  #
  # @param [String] query the substring to search for within the 'full_name' field.
  # @return [Array<Hash>] an array of client records that match the query in the 'full_name' field.
  def search_by_name(query)
    return [] unless @clients.first&.key?('full_name')

    @clients.select { |client| client['full_name'].include?(query) }
  end

  # Find duplicate emails in the client dataset.
  #
  # @return [Array<Array<Hash>>] an array of arrays containing client records with duplicate emails.
  def find_duplicates_by_email
    email_groups = Hash.new { |hash, key| hash[key] = [] }

    @clients.each do |client|
      # Assuming that that duplicate emails are case insensitive
      email = client['email'].downcase
      email_groups[email] << client
    end

    email_groups.values.select { |clients| clients.length > 1 }
  end
end
