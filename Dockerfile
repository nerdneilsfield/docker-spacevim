FROM alpine
MAINTAINER  hama<hama@jzm.xyz>

# ENV RUSTUP_TOOLCHAIN=stable-x86_64-unknown-linux-musl

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk update &&  \
    apk add --no-cache alpine-sdk && \
    apk add --no-cache git curl vim neovim && \
    apk add --no-cache  zsh nano bash nodejs  openssh &&\
    apk add --no-cache libgit2-dev nodejs-npm &&\
    apk add --no-cache python2  python3 python3-dev python3-doc  python2-dev python2-doc &&\
    apk add --no-cache luajit ruby clang cmake ca-certificates gcc musl-dev make zlib-dev openssl-dev perl &&\
    apk add --no-cache cargo@testing rust@testing &&\
    apk add --no-cache go

# RUN git clone https://github.com/rust-lang-nursery/rustup.rs.git && cd rustup.rs && cargo build --release && mv target/release/rustup-init /tmp &&\
#     chmod 777 /tmp/rustup-init && rm -rf rustup.rs


# RUN wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz &&\
#     tar xvf go1.9.linux-amd64.tar.gz &&\
#     mv go /opt/ 

RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py  &&\
    python /tmp/get-pip.py && python3 /tmp/get-pip.py && \
    pip2 install flake8 pylint  bs4 ptpython neovim &&\
    pip3 install flake8 pylint  bs4 ptpython neovim

RUN adduser -s /bin/zsh -D spacevim && \
    echo "root:Docker!" | chpasswd &&\
    echo "spacevim:Docker!" | chpasswd && \
    echo "spacevim ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \ 
    su spacevim

USER spacevim
WORKDIR /home/spacevim/

#RUN  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path

RUN    bash -c "$(curl -fsSL https://spacevim.org/install.sh)"

# RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"



RUN mkdir go && echo "export GOPATH=$GOPATH:/home/dengqi/go" >> /home/spacevim/.zshrc && echo "export PATH=$PATH:/opt/go/bin" >> /home/spacevim/.zshrc && \
    echo "export GOROOT=$GOROOT:/opt/go" >> /home/spacevim/.zshrc

COPY  init.vim /home/spacevim/.SpaceVim.d/init.vim

COPY mk_key.sh /home/spacevim/mk_key.sh


# RUN ./tmp/rustup install nightly

CMD ["/bin/true"]
