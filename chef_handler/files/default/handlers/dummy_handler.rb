require 'chef/log'

class DummyHandler < Chef::Handler
  def initialize(config = {})
    Chef::Log.debug("#{self.class.to_s} initialized.")
  end

  def report
    Chef::Log.info("DUMMYHANDLER ")
    Chef::Log.info("DUMMYHANDLER run list: #{node["run_list"].to_s}")
    Chef::Log.info("DUMMYHANDLER elapsed time: #{elapsed_time.to_s}") unless elapsed_time.nil?
    Chef::Log.info("DUMMYHANDLER start time: #{start_time.to_s}") unless start_time.nil?
    Chef::Log.info("DUMMYHANDLER end time: #{end_time.to_s}") unless end_time.nil?

    if exception
      Chef::Log.info("DUMMYHANDLER Exception: #{run_status.formatted_exception}")
      Chef::Log.info("DUMMYHANDLER  Stacktrace:")
      Chef::Log.info( Array(backtrace).join("\n"))
    end
    Chef::Log.info("DUMMYHANDLER opsworks activity: #{node["opsworks"]["activity"]}")
    
    if node["opsworks"]["activity"] == "deploy"
      node["deploy"].each do |application, deploy|
        Chef::Log.info("DUMMYHANDLER deploying repo: #{deploy["scm"]["repository"]}")
        Chef::Log.info("DUMMYHANDLER deploying app: #{application}")
      end
    end
  end
end