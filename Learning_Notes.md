# Main Learning/Testing Goals
- Github Runner in LXC
- Terraform and Ansible install via runner
- Terraform build LXC for Wazuh Host
- Ansible for configuring container

## Github runner build
- LXC install runner components
- Set runner protections
    - Restrict pull requests to only authorized

### Github Runner Steps
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
        - Initial Github action failed to return any data after a minute, cancelled job
        - altered the http request to include a timeout and some additional http response information to work with for a solution
        - realized:
            1. runs-on was improperly configured
    - SUCCESS!! Initial runner commit and API Key are operational.
- Build initial terraform file to build Debian CT.
    - Built Terraform.yml in the .github/workflows folder to set environment variables out of the secrets
    - built variables.tf and main.tf to store the environment variables and use them for terraform functions
        - Build separated API token ID secret and API token secret
        - Build Initial CT Password Secret
    - Test Terraform init and Terraform Plan
        - ran into issue with the checkout and setup terraform needing additional permissions
        