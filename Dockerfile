FROM base/archlinux
MAINTAINER  jiangzeming<hama@jzm.xyz>

# ENV RUSTUP_TOOLCHAIN=stable-x86_64-unknown-linux-musl
ENV PASSWD spacevim-docker

# ADD mirrorlist /etc/pacman.d/mirrorlist

RUN echo " mirrors-lan.geekpie.org 10.19.124.30" >> /etc/hosts

RUN pacman -Syyu --noconfirm && pacman -S --noconfirm archlinux-keyring

RUN pacman -S --noconfirm base-devel rust go git ddd valgrind cargo python python-pip python2 python2-pip ruby \
     luajit vim nano neovim python-numpy python2-numpy python-scipy clang cmake zsh openssh wget curl \
     nim nimble crystal shards  &&\
     rm -rf rm -rf /var/cache/pacman/pkg

# RUN git clone https://github.com/rust-lang-nursery/rustup.rs.git && cd rustup.rs && cargo build --release && mv target/release/rustup-init /tmp &&\
#     chmod 777 /tmp/rustup-init && rm -rf rustup.rs


# RUN wget https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz &&\
#     tar xvf go1.9.linux-amd64.tar.gz &&\
#     mv go /opt/ 

RUN pip2 install flake8 pylint  bs4 ptpython neovim &&\
    pip3 install flake8 pylint  bs4 ptpython neovim 

RUN  useradd -m -U -s /bin/zsh spacevim && \
    echo "root:Docker!" | chpasswd &&\
    echo "spacevim:${PASSWD}" | chpasswd && \
    echo "spacevim ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \ 
    su spacevim

USER spacevim
WORKDIR /home/spacevim/

#RUN  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path

RUN bash -c "$(curl -fsSL https://spacevim.org/install.sh)"

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

RUN mkdir go && mkdir -p go/src && mkdir -p go/bin && echo "export GOPATH=/home/spacevim/go" >> /home/spacevim/.zshrc && echo "export PATH=$PATH:/home/spacevim/go/bin" >> /home/spacevim/.zshrc

COPY  init.vim /home/spacevim/.SpaceVim.d/init.vim

COPY mk_key.sh /home/spacevim/mk_key.sh


# RUN ./tmp/rustup install nightly

CMD ["/bin/true"]
