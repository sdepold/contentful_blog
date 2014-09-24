require "yaml"

config_yml        = YAML.load_file("config/contentful.yml")
CONTENTFUL_CONFIG = config_yml["shared"].merge(config_yml[ENV['RACK_ENV']] || {})
