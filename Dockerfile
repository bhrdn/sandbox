FROM ubuntu:latest
MAINTAINER bhrdn <bhrdn@ieee.org>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV PYTHONIOENCODING UTF-8

RUN dpkg --add-architecture i386 \
    && apt-get update \
	&& apt-get -yq install \
	sudo \
	nano \
	gdb \
	gdbserver \
	gdb-multiarch \
	git \
	make \
	gcc \
	g++ \
	wget \
	cmake \
	pkg-config \
	libc6:i386 \
	libstdc++6:i386 \
	binutils

RUN /bin/echo -e "toor\ntoor" | passwd root

RUN useradd -m -s /bin/bash sandbox \
    && usermod -aG sudo sandbox \
    && /bin/echo -e "sandbox\nsandbox"|passwd sandbox \
    && chmod 4750 /home/sandbox \
    && mkdir -p /home/sandbox/src \
    && chown -R sandbox: /home/sandbox \
    && mkdir -p /etc/sudoers.d \
    && echo "sandbox ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sandbox \
    && echo "kernel.yama.ptrace_scope = 0" > /etc/sysctl.d/10-ptrace.conf, \
	&& sysctl -p

RUN git clone https://github.com/pwndbg/pwndbg /home/sandbox/src/pwndbg \
	&& cd /home/sandbox/src/pwndbg \
	&& ./setup.sh \
	&& echo "source /home/sandbox/src/pwndbg/gdbinit.py\n" >> /home/sandbox/.gdbinit

USER sandbox
WORKDIR /home/sandbox

CMD ["/bin/bash", "-i"]