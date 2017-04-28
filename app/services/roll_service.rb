class RollService
  attr_reader :response_message
  def initialize(uid)
    @client = ApiAiRuby::Client.new(
      client_access_token: ENV['API_AI_CLIENT_ACCESS_TOKEN'],
      api_session_id: uid
    )
  end
  def execute(message)
    @response_message = roll_dice(message[:parameters][:sides],message[:parameters][:count])
  end
  def roll_dice(sideses, counts)
    return_string = ""
    roll_hash = sideses.zip(counts).to_h
    roll_hash.each do |sides, count|
        return_string += roll_die(sides,count)
    end
    return return_string
  end
  def roll_die(sides, count)
    return_string = "You rolled #{count} d#{sides}s. Your results were "
    results = Array.new
    for i in 0..count
        results << 1 + Random.rand(sides)
    end
    return_string += array.join(',') + ". "
    return return_string
  end
end