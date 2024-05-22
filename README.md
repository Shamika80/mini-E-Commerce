# Flask E-commerce API

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A RESTful API for building an e-commerce platform using Flask, Flask-SQLAlchemy, and MySQL.

## Project Overview

This project is a demonstration of how to build a basic e-commerce backend using Flask. It provides endpoints for:

- Customer management (registration, login, logout, profile update, order history)
- Product management (CRUD operations, stock management)
- Order processing (placing, retrieving, tracking, canceling orders)
- Bonus features (order history, cancellation, total price calculation)

## Features

- **Customer Management:**
    - Registration and login with token-based authentication (JWT)
    - View/update customer profile
    - Order history retrieval
- **Product Management:**
    - CRUD operations (create, read, update, delete) for products
    - Stock level management
    - Restock low-stock products 
- **Order Management:**
    - Place orders with multiple items
    - View/track order status
    - Cancel pending/processing orders 
    - Calculate order total 
- **Authentication:**
    - Secure token-based authentication using JWT
- **Data Validation:**
    - Robust input validation using Flask-WTF
- **Error Handling:**
    - Graceful handling of errors with informative messages
- **Database:**
    - MySQL database integration with Flask-SQLAlchemy

## Installation

1. **Clone the Repository:**
