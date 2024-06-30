# Loan Management App

This README provides instructions to set up and run the Loan Management Application.

## Prerequisites

Ensure you have the following installed on your system:

- Ruby version 3.0.0 or above
- Rails version 7.1.3 or above
- PostgreSQL
- Redis

## Getting Started

### System Dependencies

Install the necessary system dependencies for Debian:

```sh
sudo apt-get update
sudo apt-get install -y nodejs postgresql
sudo apt-get install redis
```

### Configuration

1. Clone the repository:

```sh
git clone https://github.com/syed-burhan/loan_management_app.git
cd loan_management_app
```

2. Install the required gems:

```sh
bundle install
```

3. Install JavaScript dependencies:

```sh
yarn install
```

### Database Creation

Create and set up the PostgreSQL database:

```sh
rails db:create
rails db:migrate
rails db:seed
```

### Usage
1. Running the Application

```sh
bin/dev
```

2. Admin credentials:
Email: admin@example.com
Password: Admin@123
