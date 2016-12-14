# submon
Subscription Monitor

Summary
-------------------------------------------------------------------------------

submon collects subscription information from various sites through REST APIs
and generates a minecraft `whitelist` file.

Each site that submon monitors is handled via plugin allowing for additional
sites to be monitored in the future.

At the time of release, the following APIs may be supported:

- Gamewisp
- Patreon

- - -

Design
-------------------------------------------------------------------------------

submon is designed to run as a standalone script allowing for easier updating.

Separating submon from any UI (front-end) means any front-end can be used
(or replaced). Updates may take place to either the front or back end without
requiring changes to the other side.

- - -


Requirements
-------------------------------------------------------------------------------

+ Ruby 2.3.1
+ Bundler gem: `gem install bundler`

_$$ TBD $$_

- - -

Dependencies
-------------------------------------------------------------------------------

### Supporting Libraries and Info

#### OAuth2

[OAuth2 Ruby lib](https://github.com/intridea/oauth2)

#### Gamewisp

[Gamewisp Documentation](https://gamewisp.readme.io/docs/getting-started)

#### Patreon

[patreon-ruby](https://github.com/Patreon/patreon-ruby)

#### Twitch

[Twitch API](https://github.com/justintv/Twitch-API)

#### MC UUIDs

[Minecraft account/profile API example client](https://github.com/Mojang/AccountsClient)

[Quetzi Whitelist Import mod](https://github.com/Quetzi/Whitelister)

#### Google Sheets API

[Google Sheets API](https://developers.google.com/sheets/)
[Ruby Quickstart](https://developers.google.com/sheets/quickstart/ruby)
[API Client - Ruby](https://github.com/google/google-api-ruby-client)

_$$ TBD $$_

- - -

Installing submon
-------------------------------------------------------------------------------

### Linux

Clone the app from github using

    git clone https://github.com/jmcaffee/submon.git

Run the `setup` script

    ./bin/setup

Go to gamewisp and create credentials for your version of submon.

Edit and fill out `.envsetup` with the client ID and client secret obtained
from Gamewisp.

Run submon:

    source .envsetup && ./exe/submon

Follow the instructions on the screen by copy/pasting the URL into your browser
and allowing submon to access your metrics.

A token store file will be created under ~/.gamewisp containing the access and
refresh tokens provided by Gamewisp.

- - -

Configuration
-------------------------------------------------------------------------------

_$$ TBD $$_

- - -

Scheduling
-------------------------------------------------------------------------------

### Linux

#### Cron

Additional info for Ubuntu can be found at
[help.ubuntu.com](https://help.ubuntu.com/community/CronHowto).

Create a cron task to run `submon` once every hour:

    crontab -e

In the editor, enter

    05 * * * * /path/to/submon

The example above will run `submon` every hour at 5 minutes after
the top of the hour.

- - -

Contributing
-------------------------------------------------------------------------------

1. Fork it ( https://github.com/jmcaffee/submon/fork )
1. Clone it (`git clone git@github.com:[my-github-user-name]/submon.git`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create tests for your feature branch
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request


