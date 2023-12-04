class RandomTeamForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  MAX_GENERATION_ATTEMPTS = 1000

  attribute :list, :string, default: ""
  attribute :players_per_team, :integer, default: 7
  attribute :max_generation_attemps, :integer, default: MAX_GENERATION_ATTEMPTS
  attribute :gap, :integer, default: 1

  validates :list, :players_per_team, presence: true
  validate :run_custom_validations

  attr_accessor :game_day

  def save
    return false unless valid?

    game_day.update(player_list: list, players_per_team: players_per_team)
  end

  def run_custom_validations
    errors.add(:list, "debe ser mayor que los jugadores por equipo") if players_per_team_greater_than_players?
    errors.add(:players_per_team, "debe ser divisible por el total de jugadores") if non_divisible_players_per_team?
    errors.add(:list, "tiene duplicados") if duplicated_players.any?
    errors.add(:list, "contiene jugadores no válidos") if missing_players.any?
  end

  def model_name
    ActiveModel::Name.new(
      nil, nil, self.class.name.sub(/Form$/, "")
    )
  end


  def duplicated_players
    formatted_list.reduce([]) do |duplicates, name|
      duplicates << name if formatted_list.count(name) > 1 && !duplicates.include?(name)
      duplicates
    end
  end

  def missing_players
    return [] if list.blank?

    present_player_names = present_players.map { |player| player.name.downcase }
    formatted_list.reject { |name| present_player_names.include?(name.downcase) }
  end

  private

  def present_players
    @players ||= Player.select(:name, :id)
      .where('LOWER(name) IN (?)', formatted_list.map(&:downcase)).distinct
  end

  def formatted_list
    list.split("\n")
    .map(&:strip)
    .reject(&:empty?)
    .map { |line| line.gsub(/^\d+\.\s*/, '') }
  end

  def non_divisible_players_per_team?
    (formatted_list.size % players_per_team) != 0
  end

  def players_per_team_greater_than_players?
    formatted_list.size < players_per_team
  end
end
