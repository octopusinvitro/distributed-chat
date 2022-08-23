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

Before you install dependencies, checkout the [Install section on the curses gem README](https://github.com/ruby/curses#install) and make sure your system is setup correctly to use curses. Then:

```bash
bundle install
```


### To run the app

**You should always run the server first**. To run a node as a server just add the `-s` option. You can run as many clients as you want:

Make sure that the `bin/app` file has execution permissions:

```bash
chmod +x bin/app
```

Then type:

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


### About using curses

The first commit should work in all UNIX terminals. The second commit introduces the curses library, and **has only been tested in Ubuntu**.

In the first commit (no curses), messages you receive and characters you type are both printed to the same terminal. In other words, you may be typing a sentence and if you receive an incoming message before you are finished, it will be printed in the middle of your sentence (don't worry, when you hit Enter, your message will be printed and sent correctly).

Curses is introduced in the second commit to avoid this issue. It allows you to divide the terminal window into subwindows, so you can type in one area of the screen while the chat messages are printed in another. This chat has three areas: the header, the chatbox where messages are printed, and the input area where you type your messages.

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


## To do

* [ ] Try again to shrink chatbox and expand input when the text being typed in the input exceeds the width of a line. All previous attempts have failed. Maybe try with a pad for the input instead of a window.
* [ ] Handle terminal window resizing.
* [ ] Check the curses logic works on other platforms.


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
