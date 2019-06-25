FROM alpine:3.9
RUN apk --no-cache upgrade && apk --no-cache add curl php7-opcache php7-apache2 valgrind
COPY app.conf /etc/apache2/conf.d/app.conf
COPY index.php /app/index.php
ARG DD_APM_VERSION=0.28.0
ARG DD_APM_URL=https://github.com/DataDog/dd-trace-php/releases/download/${DD_APM_VERSION}/datadog-php-tracer_${DD_APM_VERSION}_noarch.apk
ARG DD_APM_FILE=datadog-php-tracer_${DD_APM_VERSION}_noarch.apk
RUN set -xe; \
    curl -o ${DD_APM_FILE} -L ${DD_APM_URL}; \
    apk add ${DD_APM_FILE} --allow-untrusted; \
    rm -f ${DD_APM_FILE}
EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]