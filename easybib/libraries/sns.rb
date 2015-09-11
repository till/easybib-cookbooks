require 'json'

module EasyBib
  module SNS
    # Send a spin-up notification about the current instance via SNS
    #
    # @return [nil]
    def self.sns_spinup_notify
      my_hostname = get_hostname(true)

      if my_hostname.include?('-load')
        sns_message = "subject: SPIN-UP notification of #{my_hostname}

        The node #{my_hostname} has gone into deployment phase and will be booted shortly after.

        Sincerely yours,
        EasyBib SNS Library
        "

        ::EasyBib::SNS.sns_notify(my_hostname, sns_message)
      end
    end

    # Send a notification via SNS
    #
    # node - AWS node objects
    # body - the actual message contents
    #
    # @return [nil]
    def self.sns_notify(node, body)
      require 'aws-sdk'

      if node.nil?
        Chef::Log.error 'Missing argument: node (AWS instance name)!'
        return
      elsif body.nil?
        Chef::Log.error 'Missing argument: body (e-mail message body)'
        return
      elsif node.fetch('easybib', {}).fetch('sns', {})['topic_arn'].nil?
        Chef::Log.error 'Mssing attribute: topic_arn (SNS topic)'
        return
      elsif node.fetch('easybib', {}).fetch('sns', {})['credentials'].nil?
        Chef::Log.error 'Missing attribute: credentials (SNS credentials)'
        return
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
