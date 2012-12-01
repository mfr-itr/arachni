# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper.rb"` to ensure that it is only
# loaded once.
#
require_relative '../lib/arachni'
require_relative '../lib/arachni/ui/cli/output'
require 'eventmachine'

@@root = File.dirname( File.absolute_path( __FILE__ ) ) + '/'

Dir.glob( @@root + 'shared/**/*.rb' ).each { |f| require f }

require @@root + 'helpers/misc'
Dir.glob( @@root + 'helpers/**/*.rb' ).each { |f| require f }

@@server_pids ||= []
@@servers     ||= {}
Dir.glob( File.join( @@root + 'servers/**', "*.rb" ) ) do |path|
    name = File.basename( path, '.rb' ).to_sym
    next if name == :base

    @@servers[name] = {
        port: random_port,
        path: path
    }
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.color = true
    config.add_formatter :documentation

    config.before( :all ) do
        #Arachni::UI::Output.mute
        #Arachni::UI::Output.debug_on

        kill_processes
        kill_servers
        kill_em

        Arachni::Framework.reset
        reset_options
        Arachni::HTTP.reset
    end

    config.after( :suite ) do
        kill_processes
        kill_servers
    end
end
