FROM python:3.9-alpine AS builder
WORKDIR /app
RUN apk add --no-cache gcc musl-dev linux-headers python3-dev
COPY requirements.txt .
RUN pip install --user -r requirements.txt
FROM python:3.9-alpine
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
WORKDIR /app
COPY --from=builder --chown=roboshop:roboshop /root/.local /home/roboshop/.local
COPY *.py *.ini /app
ENV PATH=/home/roboshop/.local/bin:$PATH
USER roboshop
EXPOSE 8080
CMD ["uwsgi", "--ini", "payment.ini"]
