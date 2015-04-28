#!/usr/bin/env bats

@test "node should be in the path" {
    [ "$(command -v node)" ]
}

@test "sinopia should be in the path" {
    [ "$(command -v sinopia)" ]
}

@test "sinopia should be running" {
    [ "$(ps aux |grep -v grep |grep sinopia)" ]
}

@test "sinopia should be listening TCP 4873" {
    [ "$(netstat -plant | grep 4873 | grep LISTEN)" ]
}
