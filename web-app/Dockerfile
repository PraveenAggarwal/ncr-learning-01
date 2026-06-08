FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
ENV APP_MESSAGE="Hello from the Edge!"
EXPOSE 5000
CMD ["python", "app.py"]
