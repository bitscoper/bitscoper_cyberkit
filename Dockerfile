# By Abdullah As-Sadeed

FROM archlinux:latest

RUN pacman -Syu --noconfirm gtk3 unzip wget

RUN wget https://github.com/bitscoper/bitscoper_cyberkit/releases/latest/download/Linux_x64_Executable.zip -O /tmp/Linux_x64_Executable.zip

RUN mkdir -p /opt/Linux_x64_Executable/

RUN unzip /tmp/Linux_x64_Executable.zip -d /opt/Linux_x64_Executable/

WORKDIR /opt/Linux_x64_Executable/

RUN chmod +x ./Bitscoper_CyberKit

CMD ["./Bitscoper_CyberKit"]
