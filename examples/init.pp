# Example usage of paw_ansible_role_kibana

# Simple include with default parameters
include paw_ansible_role_kibana

# Or with custom parameters:
# class { 'paw_ansible_role_kibana':
#   kibana_version => '7.x',
#   kibana_server_port => 5601,
#   kibana_server_host => '0.0.0.0',
#   kibana_elasticsearch_url => 'http://localhost:9200',
#   kibana_elasticsearch_username => undef,
#   kibana_elasticsearch_password => undef,
#   kibana_package => 'kibana',
#   kibana_package_state => 'present',
#   kibana_service_state => 'started',
#   kibana_service_enabled => true,
#   kibana_config_template => 'kibana.yml.j2',
#   kibana_config_file_path => '/etc/kibana/kibana.yml',
# }
