#!/bin/sh

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This file is used to generate the annotation of package info that
# records the user, url, revision and timestamp.

# Copied from hadoop core r740386

unset LANG
unset LC_CTYPE
version=$1
outputDirectory=$2
user=`whoami`
date=`date`
cwd=`pwd`
if [ -d .svn ]; then
  revision=`svn info | sed -n -e 's/Last Changed Rev: \(.*\)/\1/p'`
  url=`svn info | sed -n -e 's/URL: \(.*\)/\1/p'`
elif [ -d .git ]; then
  revision=`git log -1 --pretty=format:"%H"`
  hostname=`hostname`
  url="git://${hostname}${cwd}"
else
  revision="Unknown"
  url="file://$cwd"
fi
mkdir -p $outputDirectory/org/apache/hadoop/hbase
cat << EOF | \
  sed -e "s/VERSION/$version/" -e "s/USER/$user/" -e "s/DATE/$date/" \
      -e "s|URL|$url|" -e "s/REV/$revision/" \
      > $outputDirectory/org/apache/hadoop/hbase/package-info.java
/*
 * Generated by src/saveVersion.sh
 */
@VersionAnnotation(version="VERSION", revision="REV", 
                         user="USER", date="DATE", url="URL")
package org.apache.hadoop.hbase;
EOF
