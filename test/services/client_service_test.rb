require 'test_helper'

class ClientServiceTest < ActiveSupport::TestCase
  setup do
    json_data = File.read(Rails.root.join('test', 'fixtures', 'files', 'client_test.json'))
    @client_service = ClientService.new(json_data)
  end

  test 'should search by name' do
    results = @client_service.search_by_name('John')
    assert_equal 1, results.size
    assert_equal 'John Doe', results.first['full_name']

    results = @client_service.search_by_name('Random')
    assert_empty results
  end

  test 'should find duplicates by email' do
    results = @client_service.find_duplicates_by_email
    assert_equal 1, results.size
    assert_equal 'jane.doe@test.com', results.first.first['email'].downcase
  end
end
