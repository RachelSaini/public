FROM ks40698/public:latest

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

RUN apt-get update && \
    apt-get install -y qbittorrent-nox

CMD ["bash", "start.sh"]
