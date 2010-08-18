default[:haproxy] = {}
default[:haproxy][:stats_url] = '/haproxy?stats'
default[:haproxy][:stats_user] = 'scalarium'
default[:haproxy][:health_check_url] = '/'
default[:haproxy][:health_check_method] = 'OPTIONS'
default[:haproxy][:check_interval] = '10s'

def random_haproxy_pw
  rand_array = []
  "a".upto("z"){|e| rand_array << e}
  1.upto(9){|e| rand_array << e.to_s}

  pw = ""
  10.times do
    pw += (rand_array[rand(rand_array.size) - 1])
  end
  pw
end

default[:haproxy][:stats_password] = random_haproxy_pw
default[:haproxy][:enable_stats] = false