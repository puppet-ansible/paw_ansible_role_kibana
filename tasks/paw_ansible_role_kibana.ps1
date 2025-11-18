# Puppet task for executing Ansible role: ansible_role_kibana
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_kibana"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_kibana"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_kibana\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_kibana"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_kibana"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_kibana_version) {
  $ExtraVars['kibana_version'] = $env:PT_kibana_version
}
if ($env:PT_kibana_server_port) {
  $ExtraVars['kibana_server_port'] = $env:PT_kibana_server_port
}
if ($env:PT_kibana_server_host) {
  $ExtraVars['kibana_server_host'] = $env:PT_kibana_server_host
}
if ($env:PT_kibana_elasticsearch_url) {
  $ExtraVars['kibana_elasticsearch_url'] = $env:PT_kibana_elasticsearch_url
}
if ($env:PT_kibana_elasticsearch_username) {
  $ExtraVars['kibana_elasticsearch_username'] = $env:PT_kibana_elasticsearch_username
}
if ($env:PT_kibana_elasticsearch_password) {
  $ExtraVars['kibana_elasticsearch_password'] = $env:PT_kibana_elasticsearch_password
}
if ($env:PT_kibana_package) {
  $ExtraVars['kibana_package'] = $env:PT_kibana_package
}
if ($env:PT_kibana_package_state) {
  $ExtraVars['kibana_package_state'] = $env:PT_kibana_package_state
}
if ($env:PT_kibana_service_state) {
  $ExtraVars['kibana_service_state'] = $env:PT_kibana_service_state
}
if ($env:PT_kibana_service_enabled) {
  $ExtraVars['kibana_service_enabled'] = $env:PT_kibana_service_enabled
}
if ($env:PT_kibana_config_template) {
  $ExtraVars['kibana_config_template'] = $env:PT_kibana_config_template
}
if ($env:PT_kibana_config_file_path) {
  $ExtraVars['kibana_config_file_path'] = $env:PT_kibana_config_file_path
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_kibana"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_kibana"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
