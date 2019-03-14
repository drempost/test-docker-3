FROM ubuntu:18.04

LABEL description="test.lamp"

ENV DEBIAN_FRONTEND=noninteractive

COPY deployLAMP.sh /

RUN /deployLAMP.sh

CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]

EXPOSE 80
