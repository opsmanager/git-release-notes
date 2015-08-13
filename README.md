# git release-notes

This gem parses a git commit log, and assembles specially formatted
release notes, embedded in commit messages.

Release notes can be organised by meta-tagging them, so that release
notes can be generated for a specific meta-tag or set of meta-tags.

### release-notes embdedded in git commits

When a commit is made for a significant piece of work (for example a
PR merge commit) it is useful to add release notes that will be
targetted for users.

Raw commit messages are rarely completely user-friendly / user-oriented, so
embedding a specific note is helpful.

**Git-release-notes** is designed to then parse these notes out for
futher curation and editing before integration into a release notes or
_what's new_ page, for your project.

#### Embedded release-note

The form of a basic embedded release-note is as follows.

    <% release-note CONTENT %>

It is also possible to meta-tag a release note, like so:

    <% release-note(tag) CONTENT %>

or multiple meta-tags:

    <% release-note(tag,tag2,tag3) CONTENT %>

#### Markdown Content

CONTENT is expected to be [Markdown formatted text][markdown-ref]
however, be careful NOT to use headings with the `#` style.

Git will discard these from the commit message as comments when
stored.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-release-notes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-release-notes

## Usage

    git-release-notes list --sha SHA

Specify the SHA (required) of the starting commit (parses log from SHA
to HEAD on current branch) and list the release-notes found (if any)

### Additional options

    [--reverse=List release notes in reverse chronological order (newest -> oldest)], [--no-reverse]

    [--show-time=List release notes with SHA1 & time of commit], [--no-show-time]

    [--show-tags=List release notes showing their tags], [--no-show-tags]

    [--filter-tags=Specify a comma separated list of release note meta-tags to be included. See README for details]

## Development

After checking out the repo, run `bin/setup` to install
dependencies. Then, run `bin/console` for an interactive prompt that
will allow you to experiment. Run `bundle exec git-release-notes` to
use the code located in this directory, ignoring other installed
copies of this gem.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release` to create a git
tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/opsmanager/git-release-notes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[markdown-ref]: http://daringfireball.net/projects/markdown/basics
