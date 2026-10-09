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
        - Needed unzip installed on the LXC
        - Needed to update the checkout and terraform versions
        - Needed to add wrapper to false for Terraform
        - Commit versions.tf to provide information for main.tf and terraform
        - Update main.tf formatting for newer bpg/proxmox versus older telmate/proxmox
        - SUCCESS! Github actions was able to run and provide output for terraform init and terraform plan
    - Build in terraform format check
        - added test job to terraform.yml
            - allowing for checking formating before continuing with init/plan/etc
            - Added 2 tests terraform fmt -check & terraform validate
        - added "needs: test" to be successful before activating standard init job.
        - SUCCESS!
    - Build terraform output.tf
        - output IP address of eth0 network interface so Assigned IP can be passed back to the environment
    - Build Test for ping the started container after Terraform Apply
        - take output IP as an Env Variable and ping that IP to confirm networking

### Post First build checks
- Check internet Connection
    - Functional
- Check system setup
    - Cores, Swap, Memory, Storage all seem to be acceptable
- Check startup operation
    - Startup worked and system is operational
    - Initial Login Credentials work

#### First Build Issues
- Proxmox
    - certificate was issued to a previous IP and needed re-issued
    - priviledge separation was on
- Terraform
    - Typo in template_file_id
    - Needed to be deployed with an SSH Key for SSH Authentication to work out of the box
- LXC
    - Ping binary missing necessary permissions for runner user
        - updated ping permissions
- Ansible
    - Ran into a bunch of different issue adjusting to formatting and handling different functions
    - updated the ansible configs a lot, all updates are logged with commits
    - Before Hardening the system lynis score was 63
        - First run brought usup to 70
        - Second Successful run brought to 73 Need to look at additional steps
        - Third Successful run brought to 78
    - Ran into some misconfigurations with the ansible confiuration.
        - Should've been editing the etc/issue with regex in some cases
        - Should've been adding the Warning to 2 different issue files. Both corrected
        - UMASK Parameter needed corrected.
- Overall Issues
    - Realized that the individual sites added to wazuh connect to a static IP
    - Updated Terraform to request a specific static IP and set Gateway
        - Added additional Static_IP and Gateway_IP Secrets
    - Updated Ansible to Point to the STATIC_IP Secret in the inventories
    - Had issues with wazuh taking out my base wazuh user
        - Updated base wazuh user to change the username for ssh or other administrator Access

#### Second build Issues
- Code
    - Ran into old filename for lynis.yml "lynus.yml"
    - needed to remove the old host key from the runner container to allow recconection via ssh
        - initially changed this from root for both root and runner account, this changed ownership of the file
          from the runner account to root. updated chown and chgrp to the runner account.
    - Ansible harden was pointed at the Post config inventory, needed switched to the preconfig inventory.
        - need a second workflow for any post run changes.
    

## Ansible
- Setup
    - Installed ansible inside the runner
    - **Was missing ansible-lint, installed package.
- initial commit
    - install and start lynus as well as run initial scan and report results
- Issues
    - Had some initial issues with passing the lint check
    - Next issue was that the name "container" was used twice in the inventory file.
        - updated inventory file and updated ansible_run to include an inventory check line
    - ssh'd as runner user to clear host-key errors
    - Found out new default debian behavior prevents root login via password.
    - Corrected Terraform to default deploy the container with an SSH Key and Password
        - Tested and had first successful run on Ansible
    - Next Ansible run failed
        - determined that the wazuh user I built is overwritten by wazuh installation
        - updated initial ansible user configuration.
    
