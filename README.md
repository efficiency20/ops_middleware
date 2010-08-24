# About

Middleware for exposing information about a deployed project for use in debugging.

# Setup

## Rails

    ActionController::Dispatcher.middleware.use E20::Ops::Middleware::RevisionMiddleware, :logger => Rails.logger
    ActionController::Dispatcher.middleware.use E20::Ops::Middleware::HostnameMiddleware, :logger => Rails.logger
    ActionController::Dispatcher.middleware.use E20::Ops::Middleware::TransactionIdMiddleware, :logger => Rails.logger

# Usage

## Revision Middleware

Revisions can be queried directly by using the /system/revision endpoint:

    $ curl http://instance/system/revision
    fe09f24b4a927b6eab5db66b6a89fe960e2ff03b
    $

The current revision will be passed as an HTTP header for other requests:

    $ curl -I http://instance/
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 3304
    X-Revision: fe09f24b4a927b6eab5db66b6a89fe960e2ff03b

The current revision will also be logged upon application start:

    $ grep RevisionMiddleware log/production.log
    [E20::Ops::Middleware::RevisionMiddleware] Running: fe09f24b4a927b6eab5db66b6a89fe960e2ff03b

## Hostname Middleware

The hostname of the system that processed the request will be passed as an HTTP header:

    $ curl -I http://instance/
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 3304
    X-Served-By: fulton
    
The hostname will also be logged upon application start:

    $ grep HostnameMiddleware log/production.log
    [E20::Ops::Middleware::HostnameMiddleware] Running on: fulton

## Transaction ID Middleware

A transaction ID will be logged for each incoming request:

    $ grep TransactionIdMiddleware log/production.log
    [E20::Ops::Middleware::TransactionIdMiddleware] Transaction ID: 111d3180-91f4-012d-ce1a-549a20d01d99

The transaction ID will also be passed as an HTTP header:

    $ curl -I http://instance/
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 3304
    X-Transaction-Id: 111d3180-91f4-012d-ce1a-549a20d01d99