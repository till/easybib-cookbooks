#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Provider:: certificates
#
# Copyright 2011, Boundary
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Boundary::API

action :install do
  service "bprobe" do
    action [ :nothing ]
  end

  download_certificate_request(new_resource)
  download_key_request(new_resource)
end

action :delete do
  files = [
    "#{node[:boundary][:bprobe][:etc][:path]}/cert.pem",
    "#{node[:boundary][:bprobe][:etc][:path]}/key.pem"
  ]

  files.each do |file|
    file file do
      action :delete
    end
  end
end

private

def download_certificate_request(new_resource)
  if ::File.exist?("#{node[:boundary][:bprobe][:etc][:path]}/cert.pem")
    Chef::Log.debug("Certificate file already exists, not downloading.")
  else
    begin
      auth = auth_encode()
      base_url = build_url(new_resource, :certificates)
      headers = {"Authorization" => "Basic #{auth}"}
      
      cert_response = http_request(:get, "#{base_url}/cert.pem", headers)
      
      if cert_response
        file "#{node[:boundary][:bprobe][:etc][:path]}/cert.pem" do
          mode 0600
          owner "root"
          group "root"
          content cert_response.body
          notifies :restart, resources(:service => "bprobe")
        end
      else
        Chef::Log.error("Could not download certificate (nil response)!")
      end
    rescue Exception => e
      Chef::Log.error("Could not download certificate, failed with #{e}")
    end
  end
end

def download_key_request(new_resource)
  if ::File.exist?("#{node[:boundary][:bprobe][:etc][:path]}/key.pem")
    Chef::Log.debug("Key file already exists, not downloading.")
  else
    begin
      auth = auth_encode()
      base_url = build_url(new_resource, :certificates)
      headers = {"Authorization" => "Basic #{auth}"}
      
      key_response = http_request(:get, "#{base_url}/key.pem", headers)
      
      if key_response
        file "#{node[:boundary][:bprobe][:etc][:path]}/key.pem" do
          mode 0600
          owner "root"
          group "root"
          content key_response.body
          notifies :restart, resources(:service => "bprobe")
        end
      else
        Chef::Log.error("Could not download key (nil response)!")
      end
    rescue Exception => e
      Chef::Log.error("Could not download key, failed with #{e}")
    end
  end
end
