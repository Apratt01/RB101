def get_loan_amount
  amount = ''
  loop do
    puts "get loan"
    amount = gets.chomp
    if amount == '0'
      break
    elsif amount.to_i.to_s == amount
      break
    else
      puts 'valid_number'
    end
  end
  amount
end

amount = get_loan_amount
puts amount
