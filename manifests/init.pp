# paw_ansible_role_kibana
# @summary Manage paw_ansible_role_kibana configuration
#
# @param kibana_version
# @param kibana_server_port
# @param kibana_server_host
# @param kibana_elasticsearch_url
# @param kibana_elasticsearch_username
# @param kibana_elasticsearch_password
# @param kibana_package
# @param kibana_package_state
# @param kibana_service_state
# @param kibana_service_enabled
# @param kibana_config_template
# @param kibana_config_file_path
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_kibana (
  String $kibana_version = '7.x',
  Integer $kibana_server_port = 5601,
  String $kibana_server_host = '0.0.0.0',
  String $kibana_elasticsearch_url = 'http://localhost:9200',
  Optional[String] $kibana_elasticsearch_username = undef,
  Optional[String] $kibana_elasticsearch_password = undef,
  String $kibana_package = 'kibana',
  String $kibana_package_state = 'present',
  String $kibana_service_state = 'started',
  Boolean $kibana_service_enabled = true,
  String $kibana_config_template = 'kibana.yml.j2',
  String $kibana_config_file_path = '/etc/kibana/kibana.yml',
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
  $_par_vardir = $par_vardir ? {
    undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
    default => $par_vardir,
  }
  $playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_kibana/playbook.yml"

  par { 'paw_ansible_role_kibana-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'kibana_version'                => $kibana_version,
      'kibana_server_port'            => $kibana_server_port,
      'kibana_server_host'            => $kibana_server_host,
      'kibana_elasticsearch_url'      => $kibana_elasticsearch_url,
      'kibana_elasticsearch_username' => $kibana_elasticsearch_username,
      'kibana_elasticsearch_password' => $kibana_elasticsearch_password,
      'kibana_package'                => $kibana_package,
      'kibana_package_state'          => $kibana_package_state,
      'kibana_service_state'          => $kibana_service_state,
      'kibana_service_enabled'        => $kibana_service_enabled,
      'kibana_config_template'        => $kibana_config_template,
      'kibana_config_file_path'       => $kibana_config_file_path,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}
