#!/usr/bin/env bats

@test 'virtualbox-4.3 is installed' {
  run test "rpm -qa Virtualbox-4.3 || dpkg-query -s virtualbox-4.3"
  [ "$status" -eq 0 ]
}
