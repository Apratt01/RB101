require 'yaml'

MESSAGES = YAML.load_file('calculator_messages.yml')
LANGUAGE = 'en'

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

def integer?(num)
  num.to_i.to_s == num
end

def float?(num)
  num.to_f.to_s == num
end 

def number?(input)
  integer?(input) || float?(input)
end

def operation_to_message(op)
  case op
  when '1'
    'Adding'
  when '2'
    'Subtracting'
  when '3'
    'Multiplying'
  when '4'
    'Dividing'
  end
end

name = ''

loop do
  prompt(messages('welcome', LANGUAGE))
  name = Kernel.gets().chomp()
  if name.empty?()
    prompt(messages('valid_name', LANGUAGE))
  else
    break
  end
end

prompt("Hi #{name}")

loop do # main loop
  number1 = ''

  loop do
    prompt(messages('number1', LANGUAGE))
    number1 = Kernel.gets().chomp()

    if number?(number1)
      break
    else
      prompt(messages('invalid_number', LANGUAGE))
    end
  end

  number2 = ''

  loop do
    prompt(messages('number2', LANGUAGE))
    number2 = Kernel.gets().chomp()

    if number?(number2)
      break
    else
      prompt(messages('invalid_number', LANGUAGE))
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
        1) Add
        2) Subtract
        3) Mulitply
        4) Divide
  MSG

  prompt(operator_prompt)

  operator = ''

  loop do
    operator = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt("Must choose 1, 2, 3, or 4")
    end
  end

  prompt("#{operation_to_message(operator)} the two numbers...")

  result = case operator
           when '1'
             number1.to_f() + number2.to_f()
           when '2'
             number1.to_f() - number2.to_f()
           when '3'
             number1.to_f() * number2.to_f()
           when '4'
             number1.to_f() / number2.to_f()
           end

  prompt("The result is #{result}")

  prompt(messages('another_calc', LANGUAGE))
  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?('y')
end

prompt(messages('goodbye', LANGUAGE))
