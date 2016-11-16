# 1.3.3 (2016-11-16)

* Bug fixes
    * exrm and relx are updated to fix issue with non-readable sys.config

# 1.3.2 (2016-11-08)

* Bug fixes
    * various dependency updates to fix metrics configuration
    * `mock` is now a test dependency

# 1.3.1 (2016-10-28)

* Bug fixes
    * lager updated to 3.2.2 which contains bug fixes for log rotation
    * hello updated to 3.3.0 which ctaonins bug fix for requests timeouts
    * added missed exlager to conform schema

# 1.3.0 (2016-10-18)

* Enhancements
  * added support of elixir-1.3
  * unimux moved to conform and exrm from upstream

# 1.2.11 (2016-10-06)

* Bug fixes
  * Set listener IP for distributed erlang to localhost

# 1.2.10

* Enhancements

  * added support of elixir-1.2

# 1.2.9

* Enhancments
  * updated exrm and metricman (including influxdb reporter)

# 1.2.8

* Enhancements
  * update config files

# 1.2.7

* Enhancements
  * add default timeout for routes

# 1.2.6

* Enhancements
  * improve config translations
  * add configurable options for each route
  * update hello for improve logging

# 1.2.5

* Enhancements
  * Get rid of dnssd
  * update dependencies hello, metricman to have better logging and disable default metric backend

# 0.2.3

* Enhancements
  * dependency bump exrm and conform

# 0.2.2

* Enhancements
  * take exrm from xerions repository
  * add travis tests with Elixir 1.1.0 and Erlang 17.4
  * test conform schema
  * fix feature to exclude dependencies in release phase

# 0.2.1

* Enhancements
  * update hello version to 3.1.0
  * add travis
  * add metricman
  * add coverex

# 0.2.0

* Enhancements
  * update to hello with better http-client

* Backwards incompatible changes
  * a.b.c matched on a now, before it has not matched on it

# 0.1.4

* Bug fixes
  * fix .schema file

# 0.1.3

* Bug fixes
  * update jsx format dependency

# 0.1.2

* Bug fixes
  * update hello, to support http ip:port in clients without dns

# 0.1.1

* Bug fixes
  * use path option for releases

# 0.1.0

First release!
