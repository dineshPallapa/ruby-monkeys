def solution(log_string)
  logs_hash = Hash.new{ |h,k| h[k] = [] }
  logs = log_string.split("\n")
  logs.each do |log|
    time, phone = log.split(",")
    logs_hash[phone] << time
  end
  removed_number_log = update_string_to_secods_add_promo(logs_hash)
  return get_number_of_secods(removed_number_log)
end

def update_string_to_secods_add_promo(call_log_hash)
  convert_string_to_seconds = Hash.new{ |h,k| h[k] = [] }
  call_log_hash.each do |phone, call_seconds|
    call_seconds.each do |second|
      convert_string_to_seconds[phone] << calculate_seconds_from_string(second)
    end
  end

  convert_sum_of_seconds = Hash.new
  convert_string_to_seconds.each do |phone, call_seconds|
    if(call_seconds.length < 1)
      convert_sum_of_seconds[phone] = call_seconds
    else
      convert_sum_of_seconds[phone] = sum_all_cost(call_seconds)
    end
  end
  max_key = convert_sum_of_seconds.max_by { |phone, seconds| seconds }.first
  call_log_hash.delete(max_key)
  return call_log_hash
end

def get_number_of_secods(log_hash)
  total_seconds = []
  log_hash.each do |phone, times|
    if times.length == 1
      total_seconds << calculate_seconds_from_string(times.first)
    elsif
      times.each do |time|
        total_seconds << calculate_seconds_from_string(time)
      end
    end
  end
  return calculate_cost_for_a_call(total_seconds)
end

def calculate_cost_for_a_call(total_seconds)
  cost_for_seconds = []
  total_seconds.each do |seconds|
    if seconds == 300
      format_seconds = seconds_to_time(seconds)
      hh, mm, ss = format_seconds.split(":")
      cost_for_seconds << mm.to_i * 150
    elsif seconds < 300
      cost_for_seconds << seconds * 3 # 3cents for second
    elsif seconds > 300
      format_seconds = seconds_to_time(seconds)
      hh, mm, ss = format_seconds.split(":")
      if ss.to_i == 0
        cost_for_seconds << mm.to_i * 150
      else
        mm = mm.to_i + 1
        cost_for_seconds << mm.to_i * 150
      end
    end
  end
  return sum_all_cost(cost_for_seconds)
end

def sum_all_cost(total_amounts)
  total_amounts.inject(0, :+)
end

def calculate_seconds_from_string(string)
  h, m, s = string.split(":").map(&:to_i)
  h %= 24
  (((h * 60) + m) * 60) + s
end

def seconds_to_time(seconds)
  [seconds / 3600, seconds / 60 % 60, seconds % 60].map { |t| t.to_s.rjust(2,'0') }.join(':')
end

# def apply_promotion_for_a_call
#   #fucking logic I didn't understood.
#   #All calls to the phone number that the longest total duration of calls are free.
#   #In this case of tie,
#   #If more than one phone number share the longest total duration
#   #the promotion is applied only to the phone number whose numerical value is the smallest amongthe phone numbers
# end

solution("00:01:07,400-234-090\n00:05:01,701-080-080\n00:05:00,400-234-090")
