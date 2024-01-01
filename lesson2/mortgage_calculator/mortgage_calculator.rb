require 'yaml'
MESSAGES = YAML.load_file('mortgage_messages.yml')

# allows the use of variables in the YAML file
def format_message(key, *args)
  message_template = MESSAGES[key]
  formatted_message = "=> #{message_template % args}"
  puts formatted_message
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

def hanging_zero!(num) # solves edge case, if user enters 0.50 instead of 0.5
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
  format_message('zero')
  answer = gets.chomp.downcase
  answer == 'y'
end

def formatting(num) # formats numbers to 2 decimal places and adds commas
  num = format("%.2f", num)
  num.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

def get_name
  name = ''
  loop do
    format_message('welcome')
    name = gets.chomp
    if name.empty? || name.start_with?(' ')
      format_message('valid_name')
    else
      break
    end
  end
  name
end

def get_loan
  format_message('loan_amount')
  amount = gets.chomp
  hanging_zero!(amount)
end

def loan_validation
  amount = ''
  loop do
    amount = get_loan
    break if number_and_positive?(amount)
    if amount == '0'
      format_message('zero_loan')
    else
      format_message('invalid_entry')
    end
  end
  amount
end

def get_apr
  format_message('apr_amount')
  percent = gets.chomp
  hanging_zero!(percent)
end

def apr_validation
  percent = ''
  loop do
    percent = get_apr
    if number_and_positive?(percent) || zero?(percent)
      break
    else
      format_message('invalid_entry')
    end
  end
  percent
end

def get_loan_year
  format_message('loan_year')
  gets.chomp
end

def loan_year_validation
  year = ''
  loop do
    year = get_loan_year
    if whole_and_positive?(year) || zero?(year)
      break
    else
      format_message('invalid_entry')
    end
  end
  year
end

def get_loan_month
  format_message('loan_month')
  gets.chomp
end

def loan_month_validation
  month = ''
  loop do
    month = get_loan_month
    if whole_and_positive?(month) || zero?(month)
      break
    else
      format_message('invalid_entry')
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
  if time == 0
    loan
  elsif apr == '0'
    loan.to_f / time
  else
    apr = monthly_apr(apr)
    loan.to_f * (apr / (1 - ((1 + apr)**(-time))))
  end
end

user = get_name

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

  format_message('summary', loan_amount, apr, loan_duration, monthly_payment)
  format_message('another_calc')
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

format_message('goodbye', user)
