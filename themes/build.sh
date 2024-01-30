#!/bin/bash

# SPDX-FileCopyrightText: 2023 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

themes_DIR="./../themes"

mkdir -p "$themes_DIR"

for i in $(ls -d */); do
    jar cvfM "$themes_DIR/${i:0:-1}.jar" -C ${i:0:-1} .
done;

