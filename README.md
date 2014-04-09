Efficiency 2.0 Ops Middleware
=============================

A collection of useful middleware for exposing information about deployed Rack
applications. Efficiency 2.0 uses this to track distributed transactions
across its Ruby-based service oriented architecture.

Features
--------

* Adds a `X-Served-By` header with the hostname of the server that processed
  the request.
* Adds a `X-Transaction` header with a unique ID for the web request.
* Adds a `X-Revision` header with the running Git revision.
* Adds an endpoint of `/system/revision` for easily checking the running
  revision. This can be leveraged in a post-deployment sanity check to ensure
  the application servers restarted properly.

Install
-------

### Rails ###

Add to your `Gemfile`:

    gem "e20_ops_middleware", :require => "e20/ops/middleware"

Install the gem:

    $ bundle install

Create a `config/initializers/ops_middleware.rb` with the following:

    Rails.application.middleware.with_options :logger => Rails.logger do |m|
      m.use E20::Ops::Middleware::RevisionMiddleware
      m.use E20::Ops::Middleware::HostnameMiddleware
      m.use E20::Ops::Middleware::TransactionIdMiddleware
    end

### Rack ###

In `config.ru`, add:

    use E20::Ops::Middleware::RevisionMiddleware
    # alternatively, you may specify the git endpoint:
    # use E20::Ops::Midleware::RevisionMiddleware path_info: '/some/other/revision/endpoint'
    use E20::Ops::Middleware::HostnameMiddleware
    use E20::Ops::Middleware::TransactionIdMiddleware

Usage
-----

The information exposed by the middleware can be viewed manually with `curl`
and will also be logged to the provided logger (or STDOUT). Additionally,
we've found it useful to log this information when receiving responses from
REST web services.

### Revision Middleware ###

Revisions can be queried directly by using the `/system/revision` endpoint:

    $ curl http://instance/system/revision
    fe09f24b4a927b6eab5db66b6a89fe960e2ff03b

The current revision will be passed as an HTTP header for other requests:

    $ curl -I http://instance/
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 3304
    X-Revision: fe09f24b4a927b6eab5db66b6a89fe960e2ff03b

The current revision will also be logged upon application start:

    $ grep RevisionMiddleware log/production.log
    [E20::Ops::Middleware::RevisionMiddleware] Running: fe09f24b4a927b6eab5db66b6a89fe960e2ff03b

### Hostname Middleware ###

The hostname of the system that processed the request will be passed as an
HTTP header:

    $ curl -I http://instance/
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 3304
    X-Served-By: fulton

The hostname will also be logged upon application start:

    $ grep HostnameMiddleware log/production.log
    [E20::Ops::Middleware::HostnameMiddleware] Running on: fulton

### Transaction ID Middleware ###

A transaction ID will be logged for each incoming request:

    $ grep TransactionIdMiddleware log/production.log
    [E20::Ops::Middleware::TransactionIdMiddleware] Transaction ID: 111d3180-91f4-012d-ce1a-549a20d01d99

The transaction ID will also be passed as an HTTP header:

    $ curl -I http://instance/
    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 3304
    X-Transaction: 111d3180-91f4-012d-ce1a-549a20d01d99

Thanks
------

Thanks to Efficiency 2.0 ([http://efficiency20.com](http://efficiency20.com))
for sponsoring development of this gem.

Development
-----------

To run the tests:

    $ bundle install
    $ rake

License
-------

(The MIT License)

Copyright © 2010 Efficiency 2.0, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the ‘Software’), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
