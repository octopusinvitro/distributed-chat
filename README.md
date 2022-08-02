[![Build status](https://gitlab.com/octopusinvitro/distributed-chat/badges/main/pipeline.svg)](https://gitlab.com/octopusinvitro/distributed-chat/commits/main)
[![Test Coverage](https://api.codeclimate.com/v1/badges/543b7cad68021f7ecb90/test_coverage)](https://codeclimate.com/github/octopusinvitro/distributed-chat/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/543b7cad68021f7ecb90/maintainability)](https://codeclimate.com/github/octopusinvitro/distributed-chat/maintainability)
[![Dependency status](https://badges.depfu.com/badges/a5f9aa0eb83998a1a81f7b1298a0b4f8/overview.svg)](https://depfu.com/github/octopusinvitro/distributed-chat?project=Bundler)


# Readme

Distributed chat


## Folder structure

* `bin `: Executables
* `lib `: Sources
* `spec`: Tests


## How to use this project

This is a Ruby project. Tell your Ruby version manager to set your local Ruby version to the one specified in the `Gemfile`.

For example, if you are using [rbenv](https://cbednarski.com/articles/installing-ruby/), install the right Ruby version:

```bash
rbenv install < VERSION >
```

You will also need to install the `bundler` gem, which will allow you to install the rest of the dependencies listed in the `Gemfile` of this project:

```bash
gem install bundler
rbenv rehash
```


### To initialise the project

```bash
bundle install
```


### To run the app

**You should always run the server first**. To run a node as a server just add the `-s` option. You can run as many clients as you want.

Make sure that the `bin/app` file has execution permissions:

```bash
chmod +x bin/app
```

Then just type:

```bash
bin/app -s
```

If this doesn't work you can always do:

```bash
bundle exec ruby bin/app -s
```

**Both server and clients have to run in the same address**. By default it is `127.0.0.1:3000`, but you can set it to a different address with the `-a` option:

```bash
# Server
bin/app -a 127.0.0.1:4567 -s
```

```bash
# Clients
bin/app -a 127.0.0.1:4567
```

## Tests


### To run all tests and rubocop

```bash
bundle exec rake
```


### To run a specific test file


```bash
bundle exec rspec path/to/test/file.rb
```


### To run a specific test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```


### To run rubocop

```bash
bundle exec rubocop
```


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
