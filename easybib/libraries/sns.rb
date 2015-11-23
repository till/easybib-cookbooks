require 'json'
require 'aws-sdk'

module EasyBib
  module SNS
    # Send a spin-up notification about the current instance via SNS
    #
    # @return [nil]
    extend self
    def sns_notify_spinup(node, client)
      @client = client

      my_hostname = ::EasyBib.get_hostname(node, true)

      if my_hostname.include?(node['easybib']['sns']['notify_spinup'])
        sns_message = "SPIN-UP notification for #{my_hostname}

        The instance #{my_hostname} has just been deployed and will now be booted.

        Sincerely yours,
        EasyBib SNS Library
        "

        sns_notify(node, sns_message)
      end
    end

    private

    # Send a notification via SNS
    #
    # node - AWS node objects
    # body - the actual message contents
    #
    # @return [nil]
    def sns_notify(node, body)
      if body.nil?
        Chef::Log.error 'Missing argument: body (e-mail message body)'
        return false
      end

      if node['easybib']['sns']['topic_arn'].nil?
        Chef::Log.error 'Missing attribute: topic_arn (SNS topic)'
        return false
      end

      begin
        resp = @client.publish(
          :topic_arn => node['easybib']['sns']['topic_arn'],
          :message => body
        )
        Chef::Log.info "notified sns with message id #{resp[:message_id]}"
      rescue ::AWS::SNS::Errors::ServiceError => e
        Chef::Log.warn "unable to send SNS notification: #{e}"
        return false
      end

      true
    end
  end
end
