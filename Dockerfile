################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################
# Build
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app

COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn dependency:resolve

COPY src ./src
COPY tools ./tools
RUN --mount=type=cache,target=/root/.m2 mvn -f ./pom.xml clean install

# stage
FROM openjdk:11-jre

COPY --from=build /app/target/flink-operator-1.0-SNAPSHOT.jar /

CMD ["java", "-jar", "/flink-operator-1.0-SNAPSHOT.jar"]
