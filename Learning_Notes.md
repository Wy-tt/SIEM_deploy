# Main Learning/Testing Goals (H1)
- Github Runner in LXC
- Terraform and Ansible install via runner
- Terraform build LXC for Wazuh Host
- Ansible for configuring container

## Github runner build (H2)
- LXC install runner components
- Set runner protections
    - Restrict pull requests to only authorized

### Github Runner Steps (H3)
- Settings
  - Actions
  - Runners
    - New Self-Hosted Runner
        - Needed to Update the LXC and install Curl
        - Created user for runner
        - Installed and configured runner
        - runner status is visible in Github
**SUCCESS!!**

#### Github Runner errors
- Installed runner as root
    - removed installation
    - built user specific for the runner
    - downloaded runner software again as runner user
        - ran configuration succesfully
- Runner group not found
    - Used default group due to not having enterprise license
    - Default work folder


## Terraform
- Build User permissions in Proxmox
    - Create Role TerraformProv
    - Create User terraform-prov@pve
    - Create API Token and save to Github secrets for the Repo
- Build test yml file to attempt to validate the API Token
    - .github/workflows folder
