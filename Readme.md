# COBOL-Age Project

## Introduction

Welcome to the COBOL-Age project! 

This project was created to celebrate my birthday and to learn about COBOL, one of the oldest programming languages still in use today, which had its first specification published on December 17, 1959. 

Combining something old with something new, I have wrapped it with a tiny golang server to make it a microservice.

I hope you enjoy exploring the COBOL-Age project as much as I enjoyed creating it!


## Components

The application consists of two main components:


### Go HTTP Server

listens for incoming HTTP requests on port 8080. Upon receiving a request, it executes the compiled COBOL program and redirects its output to the HTTP response.

### COBOL Program

calculates the age of COBOL from its birth date (December 17, 1959) to the current date. It outputs the age in years, months, and days.

## Automated Build and Deployment

The project includes a Dockerfile and a `docker-compose.yml` file for automated building and deployment. To start the application, simply run the following command:

```sh
docker compose up --build
```

After the build and deployment process is complete, open your browser and navigate to http://localhost:8080 to see the response.

## Not interested in building it?

Then just open https://cobol-age.fly.dev/ to see the output :)