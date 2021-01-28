FROM python:3.6-alpine AS base

FROM base AS builder
WORKDIR /rates
ADD . /rates
RUN apk add py3-pip postgresql-dev gcc python3-dev musl-dev
RUN pip install -r requirements.txt --prefix=/install


FROM base
COPY --from=builder /install /usr/local/
WORKDIR /rates
ADD . /rates
RUN apk --no-cache add libpq 
CMD ["gunicorn","-b",":3000","wsgi"]

