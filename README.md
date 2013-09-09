condition
=========

A sample app intended to behave like a monitoring status slave.  Used as a testbed to experiment with Cucumber.

To setup the app for tests and running:

    bundle install
    rake db:create db:migrate

To run the tests:

    rake

To run the app:

    rails server
    point your browser to: http://127.0.0.1:3000/status

To drive the API via cURL:

    curl http://127.0.0.1:3000/status -X PUT -d "status[code]=UP&status[message]=All is good"
    curl http://127.0.0.1:3000/status -X PUT -d "status[code]=DOWN&status[message]=Alas, the site is down"
    curl http://127.0.0.1:3000/status -X PUT -d "status[code]=DOWN"

    (cause an error) curl http://127.0.0.1:3000/status -X PUT -d "status[code]=FOO"

Tested using:
- Using Ruby 1.9.3-p194
- Using Rails 3.2.8
