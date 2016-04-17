## Contribution Guidelines

- Please submit improvements and bug fixes via Github pull requests or
  by sending an email to steve@chef.io in git's format-patch
  format.

- All patches should have well-written commit message.  The first line
  should summarize the change while the rest of the commit message
  should explain the reason the change is needed.

- Please ensure all tests and lint checking pass before submitting
  pull requests.

## Development

### Requirements

- Ruby 2.0+
- Bundler (`gem install bundler`)
- [Vagrant](https://vagrantup.com)
- [VirtualBox](https://virtualbox.org)

### Development Flow

1. Clone the git repository from GitHub:

        $ git clone git@github.com:stevendanna/logrotate.git

2. Install the dependencies using bundler:

        $ bundle install

3. Create a branch for your changes:

        $ git checkout -b my_bug_fix

4. Make any changes

5. Write tests to support those changes. It is highly recommended you
   write both unit and integration tests.

6. Run the tests:
    - `make travis`
    - `kitchen test`

7. Assuming the tests pass, open a Pull Request on GitHub
