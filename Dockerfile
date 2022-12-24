FROM python:3.12-rc-slim
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 81
CMD ["python", "app.py"]