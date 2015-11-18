 Package | External Version | Comment
------------ | ------------- | -------------
apt| [2.5.3](https://github.com/opscode-cookbooks/apt/tree/v2.5.3) | added apt::easybib, apt::mirror.rb, apt::ppa, apt::proxy, apt::repair.rb, apt::updater.rb
ark| [0.9.0](https://github.com/burtlo/ark/tree/v0.9.0) |  removed 7-zip and windows dep
build-essential| [2.0.2](https://github.com/opscode-cookbooks/build-essential/tree/v2.0.2) |
chef_handler| [1.1.6](https://github.com/opscode-cookbooks/chef_handler/tree/v1.1.6) |
chef_handler_sns| [1.0.0](https://github.com/onddo/chef_handler_sns-cookbook/tree/1.0.0) | Added custom body_template
cron| [1.3.12](https://github.com/opscode-cookbooks/cron/tree/v1.3.12) |  - We are using 1.3.0, with a backported libraries/matchers.rb from 1.3.12
erlang | [1.5.6](https://github.com/opscode-cookbooks/erlang/commit/2af91e4650c1411fbf8e44626b1a548f777926c4) | ignored in our cs/test setup
fail2ban | 2.2.1 | removed yum dependencies, adapted to our rubocop scheme, changed attributes/default.rb
logrotate | [master](https://github.com/cookbooks/logrotate/commit/d7eca3a8fef69aa489c1236ed1761c364d26fdf8) | 
mysql | [6.1.2](https://github.com/chef-cookbooks/mysql/commit/4ba145f2d6e5fd710ba586bc86d9f78e35fbfa60) | disabled yum and smf deps
nodejs | [2.4.0](https://github.com/redguide/nodejs/releases/tag/v2.4.0) | disabled deps on `homebrew` and `yum-epel`, added new install method in [d606ee](https://github.com/till/easybib-cookbooks/commit/d606ee9851390458e390a44875afaecc5277c219) and a minor [bugfix](https://github.com/till/easybib-cookbooks/commit/da0895e9f3813d7bf6e646fec2615a4756e3039d)
ohai| 2.0.1 |
rabbitmq | [3.4.0](https://github.com/jjasghar/rabbitmq/commit/b71c0a068419ad10324e8d13b517fafbf373c0c3) | removed yum, ignored in our cs/test setup
xml| [1.2.4](https://github.com/opscode-cookbooks/xml/tree/v1.2.4) |
python | [master](https://github.com/poise/python/commit/56424ab64b06f584c13dba2dbb1cc5369faf20f4) |
sinopia | [0.3.0](https://github.com/BarthV/sinopia-cookbook/releases/tag/0.3.0) | removed dependency `user` cookbook
supervisor | [master](https://github.com/poise/supervisor/commit/0806cb6fccfdaf3da5959ce9c2bc42287ad50b26) |
vagrant | 0.2.2 | disabled dependency on dmg and windows
virtualbox | 1.0.3 | disabled dependency on yum, dmg, windows and apache2
runit | [master](https://github.com/hw-cookbooks/runit/commit/1ebeffa0f907811302a22b137015012ed6f11193) | dependency on packagecloud disabled
route53 | [fc5993781628ba2063b8620aecf7a5a8bcad14d2](https://github.com/optimizely/route53) |
