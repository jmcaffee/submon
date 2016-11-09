# submon
Subscription Monitor

Summary
-------------------------------------------------------------------------------

submon collects subscription information from various sites through REST APIs
and generates a minecraft `whitelist` file.

Each site that submon monitors is handled via plugin allowing for additional
sites to be monitored in the future.

At the time of release, the following APIs are supported:

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

_$$ TBD $$_

- - -

Installing submon
-------------------------------------------------------------------------------

### Linux

Extract the `submon-*-.7z` and run the installer script with sudo:

    sudo ./install.sh

The install script will install submon to `/usr/local/src/` and
create a link in `/usr/local/bin`.

The uninstall script will remove the link and src directories.

If updating, run the `uninstall.sh` to remove the old version, then run the
`install.sh` script to install the new version.

You should keep your configuration files in your home dir (or a subdirectory
of your home dir [`.submon` by default]) so uninstalling and
reinstalling the app will not mess with your configuration.

- - -

Configuration
-------------------------------------------------------------------------------

The first time submon is run, you'll need to configure it.

Start submon with the `--init` command line option.

### Linux

    submon --init

Complete the questions with your information.

_$$ List out the questions and what they are for $$_

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

    05 * * * * /usr/local/bin/submon

The example above will run `submon` every hour at 5 minutes after
the top of the hour.

- - -

Building
-------------------------------------------------------------------------------

The following rake tasks will clean the build and dist dirs, then build
the scripts and bundle the result into a 7-zip (`7z`) archive.

    rake build:clean dist:clean dist

The distro can be found in `dist`.

Additional tasks can be listed with

    rake -T

- - -

Testing
-------------------------------------------------------------------------------

`guard` is supported for testing submon.

To successfully run the gamewisp tests, you'll need your gamewisp API key.
Create a file named `.envsetup` in the project root containing the following:

    #!/bin/bash
    # vi: ft=shell

    export GAMEWISP_API_KEY=PUT_YOUR_KEY_HERE

Replace `PUT_YOUR_KEY_HERE` with your API key and save it.

Before running tests, in the terminal you'll start the tests from,
source `.envsetup` file, then run your tests.
The tests will look for the API key in the environment variables.

    $ source ./.envsetup
    $ bundle exec rspec

Or, if using guard:

    $ source ./.envsetup
    $ bundle exec guard

`.envsetup` is ignored in `.gitignore` so you don't have to worry about your
API key getting uploaded/committed to the repo.

- - -

Contributing
-------------------------------------------------------------------------------

1. Fork it ( https://github.com/jmcaffee/submon/fork )
1. Clone it (`git clone git@github.com:[my-github-username]/submon.git`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create tests for your feature branch
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request


