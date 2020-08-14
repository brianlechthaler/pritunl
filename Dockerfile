FROM centos:7
ENV PRITUNL_DIR=/opt/pritunl 
ENV VENVCMD=". /opt/pritunl/venv/bin/activate"
RUN echo "export GOPATH=\$HOME/go" >> $HOME/.bashrc"
ADD . $PRITUNL_DIR/git 

#YUM package manager dependencies
RUN yum install -y epel-release
RUN yum install -y virtualenv python2 gcc-c++ bridge-utils openvpn psmisc net-tools python-devel python-pip golang bzr

#Golang Dependencies
RUN go get -u github.com/pritunl/pritunl-dns
RUN go get -u github.com/pritunl/pritunl-web
RUN ln -s ~/go/bin/pritunl-dns /usr/bin/pritunl-dns
RUN ln -s ~/go/bin/pritunl-web /usr/bin/pritunl-web

#Python 2.x Dependencies
RUN virtualenv --python=python2 $PRITUNL_DIR/venv/
RUN $VENVCMD pip install -U pip
RUN $VENVCMD ; python setup.py build
RUN $VENVCMD pip install -r /git/requirements.txt
RUN $VENVCMD ; python setup.py install
