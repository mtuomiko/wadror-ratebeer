# Web application development with Ruby on Rails
## Ratebeer application
[![Build Status](https://app.travis-ci.com/mtuomiko/wadror-ratebeer.svg?branch=master)](https://app.travis-ci.com/mtuomiko/wadror-ratebeer)
[![Maintainability](https://api.codeclimate.com/v1/badges/13d035f0d56b93d83c4d/maintainability)](https://codeclimate.com/github/mtuomiko/wadror-ratebeer/maintainability)

Based on discontinued course material from 2018 provided by Helsinki University, Department of Computer Science.

[Course material repository](https://github.com/mluukkai/WebPalvelinohjelmointi2018) (in Finnish)

Application found at https://afternoon-garden-82317.herokuapp.com/. Hosted using [free Heroku dyno hours](https://devcenter.heroku.com/articles/free-dyno-hours) so accessing the app can take a moment while the dyno starts.

### Cheat sheet (for the forgetful...)

* `rspec spec` tests
  * Selenium setup with WSL2 assumes a running chromedriver on the Windows side. Check also that version matches actual browser version. Set env vars:
    * `WSL_SELENIUM_HOST`=local ip or host that points to the Windows
    * `WSL_SELENIUM_PORT`=9515 (default Chromedriver port)
* `rubocop` linting
* `rails server` ru
