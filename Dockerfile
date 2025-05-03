FROM ubuntu:22.04

# Suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user
ARG USERNAME=ben
ARG UID=1000
ARG GID=1000

# Install utilities, man pages, and sysadmin tools
RUN apt update && apt install -y \
    man-db manpages \
    less vim nano \
    curl wget \
    net-tools iputils-ping \
    procps lsof htop ncdu \
    sudo bash-completion \
    tree \
    locate \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Add user and give sudo rights
RUN groupadd -g $GID $USERNAME && \
    useradd -m -u $UID -g $GID -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Custom .bashrc for convenience
RUN echo "\n# Custom aliases and prompt" >> /home/$USERNAME/.bashrc && \
    echo "alias ll='ls -alF'" >> /home/$USERNAME/.bashrc && \
    echo "alias ..='cd ..'" >> /home/$USERNAME/.bashrc && \
    echo "export PS1='\\[\\e[1;32m\\]\\u@\\h:\\w\\$ \\[\\e[0m\\]'" >> /home/$USERNAME/.bashrc && \
    chown $USERNAME:$USERNAME /home/$USERNAME/.bashrc

# Set user and working dir
USER $USERNAME
WORKDIR /home/$USERNAME

# Default shell
CMD ["/bin/bash"]
