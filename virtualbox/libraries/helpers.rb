require 'open-uri'
require 'uri'

module Vbox
  module Helpers

    # Retrieves the SHA256 checksum from the VirtualBox downloads
    # site's list of checksums.
    def vbox_sha256sum(url)
      filename = ::File.basename(::URI.parse(url).path)
      urlbase = url.gsub("#{filename}", "")
      sha256sum = ""
      open("#{urlbase}/SHA256SUMS").each do |line|
        sha256sum = line.split(" ")[0] if line =~ /#{filename}/
      end
      return sha256sum
    end

    # totally assumes the version is the directory in the URL where
    # the filename is. e.g.:
    # http://download.virtualbox.org/virtualbox/4.2.8/VirtualBox-4.2.8-83876-Win.exe
    # returning "4.2.8"
    def vbox_version(url)
      version = File.dirname(URI.parse(url).path).split('/').last
      return version
    end
  end
end

Chef::Recipe.send(:include, Vbox::Helpers)
