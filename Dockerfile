from ubuntu:18.04

label description="test.lamp"

env DEBIAN_FRONTEND=noninteractive

copy deployLAMP.sh /

run /deployLAMP.sh

CMD /usr/sbin/apache2ctl -D FOREGROUND

expose 80
