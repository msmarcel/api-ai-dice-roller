class RollService
  attr_reader :response_message
  def initialize(uid)
    @client = ApiAiRuby::Client.new(
      client_access_token: ENV['API_AI_CLIENT_ACCESS_TOKEN'],
      api_session_id: uid
    )
  end
  def execute(message)
    if message[:action] == "roll"
        @response_message = roll_dice(message[:parameters][:sides],message[:parameters][:count])
    elsif message[:action] == "total"
        @response_message = total_dice(message[:parameters][:sides],message[:parameters][:count],message[:parameters][:mods])
    end
  end
  def total_dice(sideses, counts, mods)
    return_string = ""
    @total = 0
    if sideses.respond_to?(:each)
        roll_hash = sideses.zip(counts).to_h
        roll_hash.each do |sides, count|
            return_string += roll_die(sides.to_i,count.to_i)
        end
    else
        return_string += roll_die(sideses.to_i,counts.to_i)
    end
    return "The total of all your rolls was #{@total.humanize}. "
  end
  def roll_dice(sideses, counts)
    return_string = ""
    @total = 0
    if sideses.respond_to?(:each)
        roll_hash = sideses.zip(counts).to_h
        roll_hash.each do |sides, count|
            return_string += roll_die(sides.to_i,count.to_i)
        end
    else
        return_string += roll_die(sideses.to_i,counts.to_i)
    end
    return return_string
  end
  def roll_die(sides, count)
    if count > 1
        return_string = "You rolled #{count.humanize} #{sides.humanize}-sided dice. Your results were "
    else 
        return_string = "You rolled a #{sides.humanize}-sided die. Your result was "
    end
    results = Array.new
    for i in 1..count
        this_roll = 1 + Random.rand(sides)
        @total += this_roll
        results << this_roll
    end
    return_string += results.to_sentence + ". "
    return return_string
  end
end