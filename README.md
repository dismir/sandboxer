# Sandboxer

Simple gem to manage some of Jenkins builds via CLI. It deploys your current git branch to sandbox specified in the configuration. Target sandbox or branch name can be overriden by CLI command attributes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sandboxer', git: 'https://github.com/dismir/sandboxer.git'
```

And then execute:

    $ bundle

## Usage

In `config` folder of project create `sandboxer.yml` config file with such fields

```yaml
:sandboxer:
  :job_name: job_name                       # Project/Job prefix name
  :sandbox_name: sandbox_name               # Sandbox/Job name

:jenkins:
  :server_url: 'https://jenkins.sample.com' # URL to Jenkins
  :username: 'username'                     # Your Jenkins username
  :password: 'password'                     # Your Jenkins password
```

Add `config/sandboxer.yml` to the `.gitignore` file to avoid pushing it to project branch.

Execution:

    $ sandboxer

### Overriding configuration

Providing `-j` or `--job_name` will override `job_name` from config file.
Providing `-s` or `--sandbox_name` will override `sandbox_name` from config file.
Providing `-b` or `--branch_name` will override current git branch name.

Example:

    $ sandboxer -j my_job -s my_sandbox -b master

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dismir/sandboxer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
