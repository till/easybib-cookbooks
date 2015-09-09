require 'json'
require 'aws-sdk'

module EasyBib
  module SNS
    def self.sns_notify(node)
      begin
        args = {
          :region => 'us-east-1',
          :credentials => node['easybib']['sns']['credentials']
        }

        client = ::Aws::SNS::Client.new(args)
        resp = client.publish(
          :topic_arn => node['easybib']['sns']['topic'],
          :message => 'Hello world'
        )
        Chef::Log.info "notified sns with message id #{resp[:message_id]}"
      rescue ::Aws::SNS::Errors::ServiceError => e
        Chef::Log.warn "unable to send SNS notification: #{e}"
      end
    end
  end
end
