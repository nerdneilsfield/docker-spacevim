FROM alpine
MAINTAINER  hama<hama@jzm.xyz>
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update &&  \
    apk add --no-cache alpine-sdk && \
    apk add --no-cache git curl vim neovim && \
    apk add --no-cache  zsh nano bash nodejs  openssh &&\
    apk add --no-cache libgit2-dev nodejs-npm &&\
    apk add --no-cache python2  python3 python3-dev python3-doc  python2-dev python2-doc &&\
    apk add --no-cache luajit ruby clang cmake ca-certificates gcc musl-dev make zlib-dev openssl-dev perl &&\
    apk add --no-cache cargo@testing rust@testing &&\

ENV RUSTUP_TOOLCHAIN=stable-x86_64-unknown-linux-musl


RUN wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz &&\
    tar xvf go1.9.linux-amd64.tar.gz &&\
    mv go /opt/ \

RUN wget -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py  &&\
    python /tmp/get-pip.py && python3 /tmp/get-pip.py && \
    pip2 install flake8 pylint  pyquery bs4 ptpython neovim &&\
    pip3 install flake8 pylint pyquery bs4 ptpyhton neovim

RUN adduser -s /bin/zsh  spacevim && \
    echo "root:Docker!" | chpasswd &&\
    echo "spacevim:Docker!" | chpasswd && \
    echo "spacevim ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \ 
    su dengqi && \

WORKDIR /home/dengqi/

RUN  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 

RUN git clone https://github.com/rust-lang-nursery/rustup.rs.git && cd rustup.rs && cargo build --release && mv target/release/rustup-init /tmp &&\
    rm -rf rustup.rs


CMD ["/bin/true"]
