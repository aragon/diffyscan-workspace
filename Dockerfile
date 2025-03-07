FROM python:latest

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends pipx
RUN pipx install git+https://github.com/lidofinance/diffyscan

ADD run.sh /root
WORKDIR /workspace

CMD [ "/root/run.sh", "./diffyscan-params.json" ]
