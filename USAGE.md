### Design decisions

Interact directly with API calls like this:

    client = TranscribeMe::API::Client.new

    client.login_as_customer({username: "customer@transcribeme.com", password: PASSWORD})
    client.recordings # => [List of recording instances...]

    client.get_recording(recording_id) # => <Recording:0x007fc69e49f0b8>

    client.submit_recording(recording_id) # => true or false

Or interact through a customer object

    customer = Customer.new(username: "customer@transcribeme.com", password: PASSWORD)
  
  or
    customer = {username: "customer@transcribeme.com", password: PASSWORD}
  
  or
    customer = Struct.new(:username, :password)
  

  client.login_as_customer(customer) 
  either a hash, or a duck-typed object which either responds to [:username] and [:password] or #username and #password

