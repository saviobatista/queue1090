# ADS-B Data Pipeline

This project is a simple data pipeline that reads data from multiple hosts and stores it in compressed CSV files. The pipeline consists of three components: a RabbitMQ message queue, a producer that reads data from multiple hosts and publishes it to the queue, and a consumer that reads data from the queue and stores it in compressed CSV files.

## Getting Started
To get started, you will need to have Docker and Docker Compose installed on your machine. Once you have Docker and Docker Compose installed, you can clone this repository and run the following command to start the pipeline:

`docker-compose up`

This will start the RabbitMQ message queue, the producer, and the consumer. The producer will start reading data from the hosts specified in the HOSTS environment variable and publish it to the adsb queue. The consumer will start reading data from the adsb queue and store it in compressed CSV files in the /data directory.

## Configuration
The pipeline can be configured using environment variables in the docker-compose.yml file. The following environment variables are available:

`RABBITMQ_SERVER`: The URL of the RabbitMQ server. Defaults to amqp://guest:guest@queue:5672.
`HOSTS`: A comma-separated list of hosts to read data from. This variable is used by the producer. Defaults to 192.168.1.35,192.168.1.31,192.168.1.38.

## License
This project is licensed under the MIT License. See the LICENSE.md file for details.