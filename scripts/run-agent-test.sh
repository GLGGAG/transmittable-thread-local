#!/bin/bash
set -eEuo pipefail
cd "$(dirname "$(readlink -f "$0")")"

source bash-buddy/lib/trap_error_info.sh
source bash-buddy/lib/common_utils.sh

source ./ttl_build.sh

# do heavy operation first, decrease mvn operation count.
cu::log_then_run mvnBuildJar

cu::blue_echo 'Run agent check for Timer/TimerTask, default "ttl.agent.enable.timer.task"'
cu::log_then_run "${JAVA_CMD[@]}" -cp "$(getClasspathWithoutTtlJar)" \
    "-javaagent:$(getTtlJarPath)=ttl.agent.logger:STDOUT" \
    com.alibaba.test.ttl.threadpool.agent.check.timer.TimerAgentCheck

cu::blue_echo 'Run agent check for Timer/TimerTask, explicit "ttl.agent.enable.timer.task"'
cu::log_then_run "${JAVA_CMD[@]}" -cp "$(getClasspathWithoutTtlJar)" \
    "-javaagent:$(getTtlJarPath)=ttl.agent.logger:STDOUT,ttl.agent.enable.timer.task:true" \
    com.alibaba.test.ttl.threadpool.agent.check.timer.TimerAgentCheck
