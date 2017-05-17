require 'test_helper'

class RollServiceTest < ActiveSupport::TestCase
  setup do
    @rollservice = RollService.new "unique_number_or_character_string"
  end

  def test_data_roll_d6
    {
        :source => "agent",
        :resolvedQuery => "roll a d6",
        :action => "roll",
        :actionIncomplete => false,
        :parameters => {
          :count => [
            "1"
          ],
          :mods => [],
          :sides => [
            "6"
          ]
        }
    }
  end

  def test_data_roll_attributes
    {
        :source => "agent",
        :resolvedQuery => "roll a d6",
        :action => "roll",
        :actionIncomplete => false,
        :parameters => {
          :count => [
            "4"
          ],
          :mods => [
            "k3",
            "r1"
          ],
          :sides => [
            "6"
          ]
        }
    }
  end

  test "roll a d6" do
    test_result = @rollservice.execute test_data_roll_d6
    expected_result = /You rolled a six-sided die\. Your result was [1-6]\. The total of all your rolls was [1-6]\./
    assert test_result.match(expected_result)
  end

  test "roll attributes" do
    test_result = @rollservice.execute test_data_roll_attributes
    expected_result = /You rolled four six-sided dice\. Your results were [1-6], [1-6], [1-6], and [1-6]\. The total of all your rolls was [0-9]+\./
    assert test_result.match(expected_result)
  end
end
