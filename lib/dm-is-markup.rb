# Add all external dependencies for the plugin here
# require 'rubygems' # read [ http://gist.github.com/54177 ] to understand why this line is commented out
require 'pathname'

# Add all external dependencies for the plugin here
gem 'dm-core', '~> 0.10.2'
require 'dm-core'
gem 'dm-validations', '~> 0.10.2'
require 'dm-validations'

require 'alt/rext/class/inheritable_attributes'

# Require plugin-files
require Pathname(__FILE__).dirname.expand_path / 'dm-is-markup' / 'is' / 'markup.rb'

# Include the plugin in DM models
DataMapper::Model.append_extensions(DataMapper::Is::Markup)
DataMapper::Model.append_inclusions(DataMapper::Is::Markup::ResourceInstanceMethods)
