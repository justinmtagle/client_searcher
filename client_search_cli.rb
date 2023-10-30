require_relative 'app/services/client_service'

def main
  service = ClientService.new('client.json')

  loop do
    puts 'Choose an option:'
    puts '1. Search by name'
    puts '2. Find duplicates by email'
    puts '3. Exit'

    option = gets.chomp

    case option
    when '1'
      puts 'Enter the name query:'
      query = gets.chomp
      results = service.search_by_name(query)
      display_results(results)
    when '2'
      duplicates = service.find_duplicates_by_email
      display_duplicates(duplicates)
    when '3'
      break
    else
      puts 'Invalid option. Try again.'
    end
  end
end

def display_results(results)
  if results.empty?
    puts 'No clients found.'
    return
  end

  puts 'Clients found:'
  results.each do |client|
    puts "ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
  end
end

def display_duplicates(duplicates)
  if duplicates.empty?
    puts 'No duplicate emails found.'
    return
  end

  puts 'Duplicate emails found:'
  duplicates.each do |group|
    group.each do |client|
      puts "ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
    end
    puts '---'
  end
end

main
