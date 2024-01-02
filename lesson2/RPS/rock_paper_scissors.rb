require 'yaml'
MESSAGES = YAML.load_file('rps.yml')
VALID_CHOICES = { 'r' => 'Rock',
                  'l' => 'Lizard',
                  'sp' => 'Spock',
                  'sc' => 'Scissors',
                  'p' => 'Paper' }
GAME_RULES = { 'rock' => ['scissors', 'lizard'],
               'lizard' => ['spock', 'paper'],
               'spock' => ['scissors', 'rock'],
               'scissors' => ['paper', 'lizard'],
               'paper' => ['rock', 'spock'] }

def prompt(key, *args)
  message_template = MESSAGES[key]
  formatted_message = "=> #{message_template % args}"
  puts formatted_message
end

def valid_name?(name)
  name.empty? || name.start_with?(' ')
end

def win?(first, second)
  GAME_RULES.fetch(first).include?(second)
end

def display_results(player, computer, user)
  if win?(player, computer)
    prompt('win', user)
  elsif win?(computer, player)
    prompt('computer_win')
  else
    prompt('tie')
  end
end

def get_name
  user = ' '
  prompt('greeting')
  loop do
    user = gets.chomp
    break if !valid_name?(user)
    prompt('invalid_name')
    prompt('name')
  end
  user
end

def get_user_selection
  selection = ''
  loop do
    prompt('choices')
    selection = gets.chomp.downcase
    break if VALID_CHOICES.key?(selection)
    prompt('invalid_choice')
  end
  selection
end

def computer_selection
  VALID_CHOICES.keys.sample
end

def choice_transform(selection)
  VALID_CHOICES.fetch(selection).downcase
end

def player_score(player, computer)
  win?(player, computer)
end

def score_compare(player_score, computer_score, name)
  if player_score > computer_score
    prompt('player_winning', name)
  elsif computer_score > player_score
    prompt('computer_winning')
  else
    prompt('tied_score')
  end
end

user_name = get_name
prompt('welcome', user_name)

loop do
  player_count = 0
  computer_count = 0
  loop do
    player_choice = choice_transform(get_user_selection)
    computer_choice = choice_transform(computer_selection)
    prompt('chosen', player_choice, computer_choice)
    display_results(player_choice, computer_choice, user_name)

    player_count += 1 if win?(player_choice, computer_choice)
    computer_count += 1 if win?(computer_choice, player_choice)

    break if player_count == 3 || computer_count == 3

    prompt('current_score', user_name, player_count, computer_count)
    score_compare(player_count, computer_count, user_name)
  end

  prompt('game_winner_player', user_name) if player_count == 3
  prompt('game_winner_computer') if computer_count == 3
  prompt('play_again')
  answer = gets.chomp.downcase
  break unless answer.start_with?('y')
  player_count = 0
  computer_count = 0
end

prompt('goodbye')
