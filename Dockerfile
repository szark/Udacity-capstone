FROM python:3.9-alpine3.13

## Step 1:
# Create a working directory
WORKDIR RUN /app 

## Step 2:
# Copy source code to working directory
COPY web_app.py /app
COPY requirements.txt /app

## Step 3:
# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --no-cache-dir --upgrade pip &&\
    pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt


## Step 4:
# Expose port 80
EXPOSE 5000

## Step 5:
# Run app.py at container launch
CMD ["python", "web_app.py"]
