import args
import os
import ..setup

def parse(parser) {
  parser.add_command(
    'clean', 
    'Clear Nyssa storage'
  ).add_option(
    'cache',
    'clean packages cache',
    {
      short_name: 'c'
    }
  ).add_option(
    'logs',
    'clean logs',
    {
      short_name: 'l'
    }
  ).add_option(
    'all',
    'clean everything',
    {
      short_name: 'a'
    }
  )
}

def run(value, options, success, error) {
  var is_logs = options.get('logs', false),
      is_cache = options.get('cache', false),
      is_all = options.get('all', false)

  if !is_logs and !is_all and !is_cache is_all = true

  if is_logs or is_all {
    echo 'Cleaning logs...'
    os.remove_dir(os.join_paths(os.args[1], setup.LOGS_DIR), true)
  }
  if is_cache or is_all {
    echo 'Cleaning cache...'
    os.remove_dir(os.join_paths(os.args[1], setup.CACHE_DIR), true)
  }

  var cleaned = (is_logs and is_cache) or is_all ? (
    'log and cache'
  ) : (
    is_logs ? 'logs' : 'cache'
  )

  success('Nyssa ${cleaned} cleaned successfully!')
}
