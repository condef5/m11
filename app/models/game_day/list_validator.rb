class GameDay::ListValidator
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :list, :string

  def full_players
    cleaned_list.map do |name|
      founded_player = present_players.find { |player| player.name.downcase == name.downcase }
      { name: name, player: founded_player }
    end
  end

  def present_players
    @players ||= Player.select(:name, :id)
      .where('LOWER(name) IN (?)', player_names_from_list).distinct
  end

  def valid?
    puts "present_players.size: #{present_players.size}"
    puts "cleaned_list.count: #{cleaned_list.count}"
    present_players.size == cleaned_list.count
  end

  private

  def player_names_from_list
    cleaned_list.map(&:downcase)
  end

  def cleaned_list
    list.split("\n")
    .map(&:strip)
    .reject(&:empty?)
    .map { |line| line.gsub(/^\d+\.\s*/, '') }
  end
end
