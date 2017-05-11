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
          dice << this_die
        end
    else
        dice << counts.to_s + "d" + sideses.to_s + mods.to_s
    end
    dice_string = dice.join("+")
    if mods.respond_to?(:each)
      mods.each do |mod|
        if !mod.to_s.blank?
          dice_string += mod.to_s.gsub(/\s+/, "")
        end
      end
    elsif !mods.to_s.blank?
      dice_string += mods.to_s.gsub(/\s+/, "")
    end
    #return dice.to_sentence
    @dice_bag = DiceBag::Roll.new(dice_string)
    dice_result = @dice_bag.result()

    return roll_to_string(dice_result) + "The total of all your rolls was #{dice_result.to_s.humanize}. "
  end
  def roll_to_string(result)
    return_string = ""
    result.each do |section|
      if section.respond_to?(:count) && section.count > 1
          return_string += "You rolled #{section.count.humanize} #{section.sides.humanize}-sided dice. Your results were "
      elsif section.respond_to?(:sides)
          return_string += "You rolled a #{section.sides.humanize}-sided die. Your result was "
      end
      if (section.respond_to?(:tally))
        return_string += section.tally().to_sentence + ". "
      end
    end
    return return_string
  end
end
