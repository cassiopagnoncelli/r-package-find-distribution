#!/bin/bash

cat | grep -v "%i" | sed "s/\%e/exp(1)/g" | sed "s/\%pi/pi/g" | grep -v "false"
