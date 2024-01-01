require 'yaml'
MESSAGES = YAML.load_file('mortgage_messages.yml')

# auto adds => before every print line
def prompt(message)
  puts("=> #{message}")
end

# checks to see if variable is an integer
def integer?(num)
  num.to_i.to_s == num
end

# checks to see if variable is a float
def float?(num)
  num.to_f.to_s == num
end

# checks to see if variable is negative
def negative?(num) # solves edge case, if user enters a negative number
  num.to_i < 0
end

# checks to see if variable is zero, then calls validation
def zero?(num)
  num == '0' ? validate_zero : false
end

# checks for a number, either integer or float
def number?(input)
  (integer?(input) || float?(input))
end

# checks to see if a number, not negative, and not zero
def number_and_positive?(input)
  number?(input) && !negative?(input) && input != '0'
end

# checks to see if an integer, not negative, and not zero
def whole_and_positive?(input)
  integer?(input) && !negative?(input) && input != '0'
end

def hanging_zero?(num) # solves edge case, if user enters 0.50 instead of 0.5
  if num != '0' && num[-1] == '0' && num.include?('.')
    loop do
      num.chop!
      if num[-1] != '0'
        break
      end
    end
  end
  num
end

def validate_zero # solves edge case, zero is an error
  prompt(MESSAGES['zero'])
  answer = gets.chomp.downcase
  answer == 'y'
end

def formatting(num) # formats numbers to 2 decimal places and adds commas
  num = format("%.2f", num)
  num.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

def get_name
  loop do
    prompt(MESSAGES['welcome'])
    name = gets.chomp
    name.empty? ? prompt(MESSAGES['valid_name']) : break
  end
end

def get_loan
  prompt(MESSAGES['loan_amount'])
  amount = gets.chomp
  hanging_zero?(amount)
end

def loan_validation
  amount = ''
  loop do
    amount = get_loan
    break if number_and_positive?(amount)
    if amount == '0'
      prompt(MESSAGES['zero_loan'])
    else
      prompt(MESSAGES['invalid_entry'])
    end
  end
  amount
end

def get_apr
  prompt(MESSAGES['apr_amount'])
  percent = gets.chomp
  hanging_zero?(percent)
end

def apr_validation
  percent = ''
  loop do
    percent = get_apr
    if number_and_positive?(percent)
      break
    elsif zero?(percent)
      break
    else
      prompt(MESSAGES['invalid_entry'])
    end
  end
  percent
end

def get_loan_year
  prompt(MESSAGES['loan_year'])
  gets.chomp
end

def loan_year_validation
  year = ''
  loop do
    year = get_loan_year
    if whole_and_positive?(year)
      break
    elsif zero?(year)
      break
    else
      prompt(MESSAGES['invalid_entry'])
    end
  end
  year
end

def get_loan_month
  prompt(MESSAGES['loan_month'])
  gets.chomp
end

def loan_month_validation
  month = ''
  loop do
    month = get_loan_month
    if whole_and_positive?(month)
      break
    elsif zero?(month)
      break
    else
      prompt(MESSAGES['invalid_entry'])
    end
  end
  month
end

def time_of_loan(year, month) # calculates total loan time as months
  year_to_month = year.to_i * 12
  year_to_month + month.to_i
end

def monthly_apr(annual_apr) # converts annual apr to monthly apr
  (annual_apr.to_f / 100) / 12
end

def payment(loan, apr, time) # calculates the monthly payment
  if apr == '0'
    loan.to_f / time
  else
    apr = monthly_apr(apr)
    loan.to_f * (apr / (1 - ((1 + apr)**(-time))))
  end
end

get_name

loop do
  loan_amount = loan_validation
  apr = apr_validation
  loan_year = loan_year_validation
  loan_month = loan_month_validation
  loan_duration = time_of_loan(loan_year, loan_month)
  monthly_payment = payment(loan_amount, apr, loan_duration)

  loan_amount = formatting(loan_amount)
  apr = formatting(apr)
  monthly_payment = formatting(monthly_payment)

  prompt("Summary:
    A loan of $#{loan_amount} at an APR of %#{apr} (rounded),
    with a remaining time of #{loan_duration} months,
    has a monthly payment of $#{monthly_payment}.")

  prompt(MESSAGES['another_calc'])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt(MESSAGES['goodbye'])
