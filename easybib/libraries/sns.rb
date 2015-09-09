require 'json'

module EasyBib
  module SNS
    def self.sns_notify(node, body)
      require 'aws-sdk'

      if node.nil?
          Chef::Log.error "Missing argument: node (AWS instance name)!"
      elsif body.nil?
          Chef::Log::error "Missing argument: body (e-mail message body)"
      end

      begin
        args = {
          :region => 'us-east-1',
          :credentials => node['easybib']['sns']['credentials']
        }

        client = ::AWS::SNS::Client.new(args)
        resp = client.publish(
          :topic_arn => node['easybib']['sns']['topic'],
          :message => '#{body}'
        )
        Chef::Log.info "notified sns with message id #{resp[:message_id]}"
      rescue ::AWS::SNS::Errors::ServiceError => e
        Chef::Log.warn "unable to send SNS notification: #{e}"
      end
    end
  end
end
