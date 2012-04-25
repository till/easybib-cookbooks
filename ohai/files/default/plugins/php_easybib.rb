provides "php_easybib"

php_easybib Mash.new

php_easybib[:php_bin]  = `which php`.strip

if not php_easybib[:php_bin].empty?
  php_easybib[:pear_bin]       = `which pear`.strip
  php_easybib[:php_extensions] = []

  extensions = `#{php_easybib[:php_bin]} -m`.strip.split("\n")
  extensions.each do |line|
    if line.empty? or line[0,1] == '['
      next
    end

    php_easybib[:php_extensions].push(line)
  end
end

if not php_easybib[:pear_bin].empty?
  channel_out = `#{php_easybib[:pear_bin]} list-channels`.split("\n")

  channel_out.shift
  channel_out.shift
  channel_out.shift
  channel_out.pop

  php_easybib[:pear_channels] = []

  channel_out.each do |line|
    if line[0,4].empty?
      next
    end

    l = line.split
    if l[0].nil? || l[1].nil? || l[0].empty? || l[1].empty?
      next
    end

    php_easybib[:pear_channels].push({
      :uri   => l[0],
      :alias => l[1]
    })
  end
end
