FROM python:3.8-alpine
LABEL maintainer="shivam"
WORKDIR /app
COPY . .
RUN useradd docman
RUN pip install -r requirements.txt
ENV PORT=8080
USER docman
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 main:app
