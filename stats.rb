# Calculates mean, median, and mode
def mean(nbrs)
  nbrs.sum.fdiv(nbrs.length)
end

def median(nbrs)
  sorted = nbrs.sort
  nbrs.length.odd? ? sorted[nbrs.length / 2] : (sorted[nbrs.length / 2 - 1] + sorted[nbrs.length / 2]).fdiv(2)
end

def mode(nbrs)
  freq = Hash.new(0)
  most_freq = []
  nbrs.each { |nbr| freq[nbr] += 1 }
  sorted = freq.sort_by { |_, v| -v }
  max = sorted.first[1]
  sorted.each do |k, v|
    break if v < max

    most_freq << k
  end
  most_freq
end

def standard_dev(nbrs, mean)
  Math.sqrt(nbrs.map { |nbr| (nbr - mean)**2 }.sum.fdiv(nbrs.length - 1))
end

def variance_val(standard_dev)
  standard_dev**2
end

def run
  loop do
    choices
    case gets.chomp
    when '1'
      calc_set
    when '2'
      calc_variance_val
    when '3'
      calc_five_num_plus_extra
    when '4'
      calc_freqs
    when '5'
      geometric_distribution
    when '6'
      binomial_distribution
    when '7'
      poisson_distribution
    when '8'
      correlation_coefficient
    when '9'
      z_score
    when '10'
      z_test
    when '11'
      confidence_interval_of_population_proportions
    when '12'
      standard_error_of_sample_proportion
    when '13'
      t_statistic
    when '14'
      confidence_interval_using_t_distribution
    when '15'
      standard_error_of_a_sample_mean
    when '16'
      chi_square_statistic
    when 'e'
      break
    else
      puts 'Invalid choice'
    end
  end
end

def choices
  puts 'Enter 1 to calculate mean, median, mode, and standard deviation of a set of numbers.'
  puts 'Enter 2 to calculate variance value from standard deviation.'
  puts 'Enter 3 to calculate five number summary.'
  puts 'Enter 4 to calculate freq, relative freq, and cumulative relative freq.'
  puts 'Enter 5 to calculate geometric distribution.'
  puts 'Enter 6 to calculate binomial distribution.'
  puts 'Enter 7 to calculate poisson distribution.'
  puts 'Enter 8 to calculate correlation coefficient.'
  puts 'Enter 9 to calculate Z-score.'
  puts 'Enter 10 to calculate Z-test.'
  puts 'Enter 11 to calculate confidence interval of population proportions.'
  puts 'Enter 12 to calculate standard error of a sample proportion.'
  puts 'Enter 13 to calculate the T-statistic.'
  puts 'Enter 14 to calculate confidence interval using T-distribution.'
  puts 'Enter 15 to calculate the standard error of a sample mean.'
  puts 'Enter 16 to calculate Chi-Square statistic.'
  puts 'Enter e to exit'
end

def calc_set
  puts 'Enter a list of numbers separated by spaces: '
  nbrs = gets.chomp.split(' ').map(&:to_f)
  mean_val = mean(nbrs)
  puts "Mean: #{mean_val}"
  puts "Median: #{median(nbrs)}"
  print "Mode: #{mode(nbrs)}\n"
  sd = standard_dev(nbrs, mean_val)
  puts "Standard Deviation: #{sd}"
  puts "SD of sampling distribution of sample means: #{sd.fdiv(Math.sqrt(nbrs.length))}"
end

def calc_variance_val
  puts 'Enter standard deviation: '
  standard_dev_val = gets.chomp.to_f
  puts "Variance Value: #{variance_val(standard_dev_val)}"
end

def calc_five_num_plus_extra
  puts 'Enter a list of numbers separated by spaces: '
  nbrs = gets.chomp.split(' ').map(&:to_f)
  sorted = nbrs.sort
  puts "Minimum: #{sorted.first}"
  q1 = median(sorted[0..sorted.length / 2 - 1])
  puts "Q1: #{q1}"
  puts "Median: #{median(sorted)}"
  q3 = median(sorted[sorted.length / 2..-1])
  puts "Q3: #{q3}"
  puts "Maximum: #{sorted.last}"
  puts "Interquartile Range: #{q3 - q1}"
  puts "1.5 IQR: #{1.5 * (q3 - q1)}"
end

def calc_freqs
  puts 'Enter a list of numbers separated by spaces: '
  nbrs = gets.chomp.split(' ').map(&:to_f)
  sorted = nbrs.sort
  rel_cum_freq = 0
  freq = Hash.new(0)
  sorted.each { |nbr| freq[nbr] += 1 }
  freq.each do |nbr, count|
    rel_freq = count.fdiv(sorted.length) * 100
    puts "#{nbr} | #{count} | #{rel_freq}% | #{rel_cum_freq += rel_freq}%"
  end
end

def geometric_distribution
  puts 'Enter number of trials and probability of success: '
  nbrs = gets.chomp.split(' ').map(&:to_f)
  puts "Geometric Distribution: #{(1 - nbrs[1])**(nbrs[0] - 1) * nbrs[1]}"
end

def binomial_distribution
  puts 'Enter number of successes, number of trials, and probability of success: '
  nbrs = gets.chomp.split(' ').map(&:to_f)
  puts "Binomial Distribution: #{(nbrs[1].fdiv(nbrs[0]) * nbrs[2])**nbrs[0] * (1 - nbrs[2])**(nbrs[1] - nbrs[0])}"
  center = nbrs[1] * nbrs[2]
  puts "Mean/Center: #{center}"
  variance = center * (1 - nbrs[2])
  puts "Variance: #{variance}"
  puts "Spread/Standard Deviation: #{Math.sqrt(variance)}"
end

def poisson_distribution
  puts 'Enter number of event occurrences and average rate of event occurrences: '
  nbrs = gets.chomp.split(' ').map(&:to_f)
  puts "Poisson Distribution: #{Math.exp(-nbrs[1]) * nbrs[1]**nbrs[0] / (1..nbrs[0]).inject(:*)}"
end

def correlation_coefficient
  puts 'Enter explanatory variable values (x) separated by spaces: '
  x = gets.chomp.split(' ').map(&:to_f)
  puts 'Enter response variable values (y) separated by spaces: '
  y = gets.chomp.split(' ').map(&:to_f)
  correlation = correlation_coefficient_val(x, y)
  puts "Correlation Coefficient: #{correlation}"
  slope = correlation * standard_dev(y, mean(y)) / standard_dev(x, mean(x))
  puts "Slope: #{slope}"
  puts "Y-Intercept: #{mean(y) - slope * mean(x)}"
end

def correlation_coefficient_val(x, y)
  x_mean = mean(x)
  y_mean = mean(y)
  a_b = 0
  a_square = 0
  b_square = 0
  x.length.times do |idx|
    a_val = x[idx] - x_mean
    b_val = y[idx] - y_mean
    a_b += a_val * b_val
    a_square += a_val**2
    b_square += b_val**2
  end
  a_b.fdiv(Math.sqrt(a_square * b_square))
end

def z_score
  puts 'Enter population mean, population standard deviation, sample mean, sample size: '
  input = gets.chomp.split(' ').map(&:to_f)
  puts "Z-score: #{(input[2] - input[0]) / (input[1] / Math.sqrt(input[3]))}"
end

def z_test
  # Remember that proportions are in percentages
  puts 'Enter population proportion of successes, sample proportion of successes, sample size: '
  input = gets.chomp.split(' ').map(&:to_f)
  q = 1 - input[0]
  puts "Z-test: #{(input[1] - input[0]) / Math.sqrt((input[0] * q) / input[2])}"
end

def confidence_interval_of_population_proportions
  puts 'Enter sample proportion of successes, sample size, and confidence level(z-score): '
  input = gets.chomp.split(' ').map(&:to_f)
  q = 1 - input[0]
  value = input[2] * Math.sqrt((input[0] * q) / input[1])
  puts "Confidence Interval: #{input[0] - value} to #{input[0] + value}"
end

def standard_error_of_sample_proportion
  puts 'Enter successes, sample size: '
  input = gets.chomp.split(' ').map(&:to_f)
  success_percent = input[0] / input[1]
  q = 1 - success_percent
  puts "Standard Error: #{Math.sqrt((success_percent * q) / input[1])}"
end

def t_statistic
  puts 'Enter sample mean, sample standard deviation, sample size, and population mean:  '
  input = gets.chomp.split(' ').map(&:to_f)
  puts "T-statistic: #{(input[0] - input[3]) / (input[1] / Math.sqrt(input[2]))}"
end

def confidence_interval_using_t_distribution
  puts 'Enter sample mean, sample standard deviation, sample size, and t*: '
  input = gets.chomp.split(' ').map(&:to_f)
  value = input[3] * (input[1] / Math.sqrt(input[2]))
  puts "Confidence Interval: #{input[0] - value} to #{input[0] + value}"
end

def standard_error_of_a_sample_mean
  puts 'Enter list of numbers'
  input = gets.chomp.split(' ').map(&:to_f)
  mean = mean(input)
  sd = standard_dev(input, mean)
  puts "Standard Error: #{sd / Math.sqrt(input.length)}"
end

def chi_square_statistic
  puts 'Enter list of observed values separated by spaces: '
  input = gets.chomp.split(' ').map(&:to_f)
  puts 'Enter expected value for each observed value: '
  expected = gets.chomp.split(' ').map(&:to_f)
  chi_square = 0
  input.length.times { |idx| chi_square += (input[idx] - expected[idx])**2 / expected[idx] }
  puts "Chi-square Statistic: #{chi_square}"
end

run
