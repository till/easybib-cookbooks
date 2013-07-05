provides "languages/php"
require_plugin "languages"

languages[:php] = Mash.new unless languages[:php]

php_bin = `which php`.strip

Ohai::Log.debug("Found PHP? Maybe: #{php_bin}")

if !php_bin.empty?

  languages[:php][:php_bin] = php_bin
  languages[:php][:extension_dir] = `#{php_bin} -r 'echo ini_get("extension_dir");'`.strip

  pear_bin = `which pear`.strip

  if pear_bin.empty?
    Ohai::Log.debug("Pear not found.")
  else
    languages[:php][:pear_bin]       = pear_bin
    languages[:php][:php_extensions] = []

    extensions = `#{languages[:php][:php_bin]} -m`.strip.split("\n")
    extensions.each do |line|
      if line.empty? or line[0,1] == '['
        next
      end

      languages[:php][:php_extensions].push(line)
    end

  end
else
  Ohai::Log.error("No PHP on this server.")
end

if !languages[:php][:pear_bin].nil?

  languages[:php][:pear] = {}
  languages[:php][:pear][:bin_dir] = `#{languages[:php][:pear_bin]} config-get bin_dir`.strip
  languages[:php][:pear][:php_dir] = `#{languages[:php][:pear_bin]} config-get php_dir`.strip

  channel_out = `#{languages[:php][:pear_bin]} list-channels`.split("\n")

  channel_out.shift
  channel_out.shift
  channel_out.shift
  channel_out.pop

  languages[:php][:pear_channels] = []

  channel_out.each do |line|
    if line[0,4].empty?
      next
    end

    l = line.split
    if l[0].nil? || l[1].nil? || l[0].empty? || l[1].empty?
      next
    end

    languages[:php][:pear_channels].push({
      :uri   => l[0],
      :alias => l[1]
    })
  end
end
