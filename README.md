# SIEM Deployment

## Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [Deployment](#deployment)
- [Configuration](#configuration)
- [Verification](#verification)
- [Operations and Maintenance](#operations-and-maintenance)
- [Security Considerations](#security-considerations)
- [License](#license)

## Overview

- This was built to manage a training environment inside my Homelab. I wanted a secure container that contained a baseline security configuration.
    - Building this gave me the ability to control the deployment and configuration time and again in the instance I had any drive failures or broke the container.
- I took Notes as I went, Failures, Successes, Learning steps along with the commit messages
- The goal here was rebuildable infrastructure with configuration management made as easy as possible via runner actions and IaC

## Architecture
- Github actions
    - test_pve_token
        - Built a github runner and the initial test_pve_token action to confirm the operation of the token
    - terraform.yml
        - Startup
            - terraform init
            - terraform format check and validation
        - Action
            - Connect to the runner, Build and start the container
        - Post
            - Ping container ip to confirm Connectivity for Ansible
    - ansible_run/ansible_post
        - pre-check
            - lint ansible yml file
        - run
            - run lynis check to get a hardening score
    - ansible_harden
        - pre-check
            - lint harden yml file
        - run
            - run harden file
                - install and update all necessary packages
                - create sudo user and disable root ssh
                    - various other ssh updates

- Terraform
    - main.tf
        - build the container with base settings
            - CT Template location
            - static IP address information
            - base CPU and Memory configs
            - base hostname and container ID number
    - variables.tf
        - handle all necessary github secrets variables passed from workflow TF_VAR's
    - versions.tf
        - load versions for bpg/proxmox
    - outputs.tf
        - output container IP
            - this was more used during intial deployments when I had configured main for DHCP which was later ammended to Static IPs

- Ansible
    - lynis
        - run lynis to test base and post hardening lynis score
    - harden
        - run hardening steps to protect the base container

## Prerequisites

- Proxmox Node
    - LXC container or other Github actions runner host
    - Secrets for:
        - Proxmox API URL
        - Proxmox API Token
        - Proxmox API Token ID
        - Static container IP
        - Container Static IP/CIDR
        - Proxmox Gateway IP
        - Container Priv/Pub Key
        - Container Base Password
    - Location of the following if they don't already match the repo options:
        - CT template file on the local Proxmox Node
            - CT template used was Debian 13 for this installation
        - Name of virtual bridge for network connections
        - Name of Disk for HDD (120G currently built)

## Repository Structure

- .github\workflows
    - contain all workflow yml files
- terraform
    - contain all neccessary files for terraform build and output
- ansible
    - contain ansible files to run the lynis checks pre and post as well as the harden config file

## Deployment

1. Build user and token for proxmox API user
2. Add Github runner account to a local container or VM
3. Run Github action to test the pve token you built
4. Run Github action to terraform container inside node
5. Run Github action to install lynis and test the container base
6. Run Github action to harden configuration
7. Run Github action to post-test with lynis the container

## Security Considerations

- Before turning this into a public repo
    - removed github runner from available runners

## License
