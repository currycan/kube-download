# FROM currycan/oracle-jdk:8u201
FROM currycan/oracle-jdk:8u201-alpine

# -Xms4g -Xmx4g -XX:MaxMetaspaceSize=256m -XX:MetaspaceSize=256m -XX:MaxDirectMemorySize=256m
ENV APP_OPTS=""
ENV JVM_LOGS="/jvm/logs"
ENV MY_CPU_LIMIT="1"
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxGCPauseMillis=150 -XX:InitiatingHeapOccupancyPercent=40 -XX:ActiveProcessorCount=${MY_CPU_LIMIT} -XX:+ParallelRefProcEnabled"
# JDK8u191后加入了UseContainerSupport、MaxRAMPercentage、MinRAMPercentage、InitialRAMPercentage参数。deprecate了UseCGroupMemoryLimitForHeap、MaxRAMFraction、MinRAMFraction、InitialRAMFraction参数。
# https://help.aliyun.com/document_detail/383255.html
# https://help.aliyun.com/document_detail/98492.html
# -XX:ErrorFile=${JVM_LOGS}/hs_err_%p.log
ENV JVM_ARGS="-XX:MaxRAMPercentage=75.0 -XX:MinRAMPercentage=75.0 -XX:InitialRAMPercentage=75.0 -XX:-UseAdaptiveSizePolicy -XX:+UseContainerSupport -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
ENV JVM_GC="-XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -Xloggc:${JVM_LOGS}/gc-%t.log -XX:ErrorFile=${JVM_LOGS}/hs_err_%p.log -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -XX:+PrintClassHistogramBeforeFullGC -XX:+PrintClassHistogramAfterFullGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${JVM_LOGS}"


ENV WORKDIR /app
WORKDIR ${WORKDIR}

ENV JAR_FILE=app.jar
ADD --chown=${uid}:${gid} *.jar ${WORKDIR}/${JAR_FILE}

COPY run.sh /run.sh
RUN set -ex; \
  chmod 755 /run.sh; \
  mkdir -p ${JVM_LOGS}; \
  chown -R ${uid}:${gid} ${JVM_LOGS} ${WORKDIR} /jmx/

VOLUME [ "${JVM_LOGS}" ]

ENTRYPOINT [ "/run.sh"]

CMD [ "--file.path=/app/logs/app-demo/info.log" ]
