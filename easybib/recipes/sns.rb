chef_gem 'aws-sdk' if is_aws
::EasyBib::SNS.sns_notify(node)
