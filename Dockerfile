# By Abdullah As-Sadeed

FROM archlinux:latest

RUN pacman -Syu --noconfirm gtk3 unzip wget

RUN wget https://github.com/bitscoper/Bitscoper_Cyber_ToolBox/releases/latest/download/Linux_x64_Executable.zip -O /tmp/Linux_x64_Executable.zip

RUN unzip /tmp/Linux_x64_Executable.zip -d /opt/

WORKDIR /opt/Linux_x64_Executable

RUN chmod +x Bitscoper_Cyber_ToolBox

CMD ["./Bitscoper_Cyber_ToolBox"]

# docker build -t bitscoper_cyber_toolbox . && xhost +si:localuser:root && docker run --rm -it -e DISPLAY=$DISPLAY -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY -v /run/user/$(id -u)/wayland-0:/run/user/$(id -u)/wayland-0 -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR bitscoper_cyber_toolbox
