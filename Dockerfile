FROM ubuntu:18.04
LABEL maintainer="mindspore@mindspore.cn"
SHELL ["/bin/bash","-c"]
COPY pkgs/* /opt/pkgs/
ENV PATH="/root/miniconda3/condabin/:/root/miniconda3/bin/:${PATH}"
RUN mkdir  /root/.pip /root/.conda && \
    apt-get update && \
    apt-get install ca-certificates -y && \
    printf "Y\n"|apt-get install gcc --no-install-recommends && \
    apt-get clean && \
    printf "\nyes\n\nyes\n"|/opt/pkgs/Miniconda3-4.7.10-Linux-x86_64.sh && \
    eval "$(/root/miniconda3/bin/conda shell.bash hook)" && \
    conda env create -f /opt/pkgs/mindspore.yaml -q && \
    source activate mindspore && \
    echo -e  '[global]\nindex-url = https://pypi.douban.com/simple/' >/root/.pip/pip.conf  && \
    pip install jupyter && \
    mv -f /opt/pkgs/main.min.js  /root/miniconda3/envs/mindspore/lib/python3.7/site-packages/notebook/static/edit/js/main.min.js && \
    mv -f /opt/pkgs/login.py /root/miniconda3/envs/mindspore/lib/python3.7/site-packages/notebook/auth/login.py && \
    pip install matplotlib && \
    conda clean -a && \
    rm -r /opt/pkgs && \
    rm -r /root/.cache/pip
