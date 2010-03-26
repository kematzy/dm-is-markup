require 'pathname'
require 'rubygems'
require 'hoe'

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

require ROOT + 'lib/dm-is-markup/is/version'

# define some constants to help with task files
GEM_NAME    = 'dm-is-markup'
GEM_VERSION = DataMapper::Is::Markup::VERSION

Hoe.new(GEM_NAME, GEM_VERSION) do |p|
  p.developer('John Doe', 'john [a] doe [d] com')

  p.description = 'A DataMapper plugin that ...'
  p.summary = 'A DataMapper plugin that ...'
  p.url = 'http://github.com/USERNAME/dm-is-markup'

  p.clean_globs |= %w[ log pkg coverage ]
  p.spec_extras = { :has_rdoc => true, :extra_rdoc_files => %w[ README.txt LICENSE TODO History.txt ] }

  p.extra_deps << ['dm-core', "~>  DMGen::DM_VERSION"]

end

Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }
