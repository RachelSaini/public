FROM anasty17/mltb:latest

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

RUN bash <(curl -Ls https://github.com/Aniverse/qbittorrent-nox-static/raw/master/install.sh) -u aniverse -p only4test \
    -w 8080 -v 4.2.3.lt.1.1.14

CMD ["bash", "start.sh"]
