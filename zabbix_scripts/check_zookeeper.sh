#!/bin/bash
echo mntr | nc 127.0.0.1 2182 | grep "$1" |awk '{print $2}'
