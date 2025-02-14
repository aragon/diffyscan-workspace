FROM python:latest
WORKDIR /app

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends pipx
RUN pipx install git+https://github.com/lidofinance/diffyscan
ADD run.sh /root

ENTRYPOINT [ "/root/run.sh" ]
