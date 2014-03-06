require 'chef/log'

class Dummy2Handler < Chef::Handler
  def initialize(config = {})
    Chef::Log.debug("#{self.class.to_s} initialized.")
  end

  def report
    Chef::Log.info("DUMMYHANDLER2 ")
  end
end