class RollService
  attr_reader :response_message
  def initialize(uid)
    @client = ApiAiRuby::Client.new(
      client_access_token: ENV['API_AI_CLIENT_ACCESS_TOKEN'],
      api_session_id: uid
    )
  end
  def execute(message)
    if message[:action] == "roll" or message[:action] == "total"
        @response_message = roll_dice(message[:action],message[:parameters][:sides],message[:parameters][:count],message[:parameters][:mods])
    end
  end
  def roll_dice(action, sideses, counts, mods)
    dice_string = ""
    dice = Array.new
    if sideses.respond_to?(:each)
        for i in 0..sideses.count-1
          this_die = counts[i].to_s + "d" + sideses[i].to_s
          if mods.respond_to?(:each)
             this_die += mods[i].to_s
          end
          dice << this_die
        end
    else
        dice << counts.to_s + "d" + sideses.to_s + mods.to_s
    end
    if !mods.respond_to?(:each) and !mods.to_s.blank?
      dice << mods.to_s
    end
    dice_string = dice.join("+")
    #return dice.to_sentence
    @dice_bag = DiceBag::Roll.new(dice_string)
    dice_result = @dice_bag.result()

    if action == "total"
      return "The total of all your rolls was #{dice_result.to_s.humanize}. "
    else
      return roll_to_string(dice_result)
    end
  end
  def roll_to_string(result)
    return_string = ""
    result.each do |section|
      if section.count > 1
          return_string = "You rolled #{section.count.humanize} #{section.sides.humanize}-sided dice. Your results were "
      else
          return_string = "You rolled a #{section.sides.humanize}-sided die. Your result was "
      end
      return_string += section.tally().to_sentence + ". "
    end
    return return_string
  end
end
