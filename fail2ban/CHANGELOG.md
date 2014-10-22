v2.2.1 (2014-10-15)
-------------------
- [#24] Add default value for pidfile

v2.2.0
------
- #15 - Fix small typo in README.md for smtp
- #16 - Support custom fail2ban filters
- #21 - Service and defaults improvements, Fedora support

v2.1.2
------
### Improvement
- **[COOK-3899](https://tickets.opscode.com/browse/COOK-3899)** - Allow action override in service block


v2.1.0
------
Updating for cookbook yum ~> 3.0
Fixing style or rubocop
Updating test bits


v2.0.4
------
fixing metadata version error. locking to 3.0


v2.0.2
------
Locking yum dependency to '< 3'


v2.0.0
------
[COOK-2530] Allow customisation of jail.local


v1.2.4
------
### New Feature
- **[COOK-3383](https://tickets.opscode.com/browse/COOK-3383)** - Add clarifying caveat about rsyslog in README

### Bug
- **[COOK-3249](https://tickets.opscode.com/browse/COOK-3249)** - Fix default `jail.conf` on CentOS

### Improvement
- **[COOK-2748](https://tickets.opscode.com/browse/COOK-2748)** - Handle `/etc.init.d/fail2ban status` for older versions

v1.2.2
------
### Bug

- [COOK-2588]: Fail2ban needs to store the socket in the correct location
- [COOK-2592]: fail2ban: Update jail file template to match current config file

v1.2.0
------
- [COOK-2292] - Add fail2ban support for RHEL using EPEL
- [COOK-2426] - Fail2ban cookbook needs syslog tunables in config file
- Development repository only: test kitchen 1.0.alpha support

v1.1.0
------
- [COOK-2291] - Add additional tunables to the fail2ban cookbook

v1.0.2
------
- [COOK-2217] - Users should be able to configure the email address fail2ban uses to send messages

v1.0.0
------
- Current public release.
