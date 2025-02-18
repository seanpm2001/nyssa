import args
import io
import colors
import os
import .setup

# initialize storage directory
var storage_dir = os.join_paths(os.args[1], setup.STORAGE_DIR)
if !os.dir_exists(storage_dir)
  os.create_dir(storage_dir)

# ensure config file exists...
var config_file = os.join_paths(os.args[1], setup.CONFIG_FILE)
if !file(config_file).exists()
  file(config_file, 'w').write('{}')

# ensure the state file exists
var state_file = os.join_paths(os.args[1], setup.STATE_FILE)
if !file(state_file).exists()
  file(state_file, 'w').write('{}')

# import commands...
import .commands.account
import .commands.clean
import .commands.info
import .commands.init
import .commands.install
import .commands.restore
import .commands.doc
import .commands.uninstall
import .commands.update
import .commands.publish
import .commands.serve

# Import options...
import .options.version

var parser = args.Parser('nyssa', true)

var commands = {
  account: account,
  clean: clean,
  info: info,
  init: init,
  install: install,
  publish: publish,
  restore: restore,
  serve: serve,
  doc: doc,
  uninstall: uninstall,
  update: update,
}

var options = {
  version: version,
}

for cmd in commands {
  cmd.parse(parser)
}
for o in options {
  o.parse(parser)
}

def success(msg) {
  io.stderr.write(colors.text(
    colors.text('Success: ${msg}\n', colors.text_color.green),
    colors.style.bold
  ))
  os.exit(0)
}

def error(msg) {
  io.stderr.write(colors.text('error: ${msg}\n', colors.text_color.red))
  os.exit(1)
}

var opts = parser.parse()

if opts.options or opts.command {
  var command = opts.command
  opts = opts.options

  if command {
    commands[command.name].run(command.value, opts, success, error)
  } else if opts {
    var key = opts.keys()[0]
    options[key].get(opts[key])
  }
}
