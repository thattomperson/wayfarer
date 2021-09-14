#! /usr/bin/env bash
go run . &

GOSERVER=$!

npm run start;

kill -9 $GOSERVER;