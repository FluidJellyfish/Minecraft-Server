# A Minecraft Server


### Requirements
Terraform v1.15.5
Ansible v2.20.1
SSH key
Virtual Machine running Ubuntu


## Pipeline

Minecraft Server                          
                                                        │
├ Install dependencies                    
                                                        │
┼ Move SSH Key and Files              
                                                        │
┼ Create AWS Env Variables             
│                                                        │
┼─Run Terraform script                  
                                                         │
 |── Connect to MC server             
                                                         │
┼────────────────────  

### Terraform
Everything is done through a single command, `terraform apply`. Terraform begins by linking the created SSH key to the soon-to-be EC2 Instance. It then creates the needed security group, allowing SSH connections through port 22 and TCP connections from anywhere on port 25565 (Minecraft's default port). It then creates the EC2 instance using a t3.medium instance type running Ubuntu. The script assigns an elastic IP so that the server owner does not need to resend the IP address every time the server boots up.  

### Ansible Playbook
An Ansible playbook is used to setup the innerworkings of the server. It installs the needed dependency openjdk-21-headless. After this is installed, it pulls the server JAR file from Mojang's official website, accepts the EULA, creates a systemd service to enable the Minecraft server anytime the instance is restarted, and boots up the Minecraft server.  

## How to run
#### Step 1
Install Terraform and Ansible on your device. To connect to your EC2 instance, you will need to create three environmental variables called `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN`. These can all be found in the details page of your AWS instance. Fill in the variables with the respective keys for your AWS account. 

#### Step 2
After downloading the four files, make sure that they are all in the same directory. Then you will need to create an SSH key named Minecraft.  You can create the SSH key using the command `ssh-keygen -t rsa -f ~/.ssh/Minecraft`. Once the key is created, move it into the same directory as the other four files. 

#### Step 3
Once everything has been set up, you can run `Terraform apply` then enter `yes` when prompted to start the creation of the Minecraft server. 

#### Step 4
Give the server a couple of minutes to boot up once the EC2 instance is created. Once it is finished starting, you can connect to it through your Minecraft client using the IP that was output from the Terraform script along with port 25565. `IP_ADDRESS:25565`











## Sources/Resources
1. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip 
2. https://stackoverflow.com/questions/32297456/how-to-ignore-ansible-ssh-authenticity-checking
3. https://www.shells.com/l/en-US/tutorial/0-A-Guide-to-Installing-a-Minecraft-Server-on-Linux-Ubuntu
4. https://www.reddit.com/r/admincraft/comments/r81fag/minecraft_server_as_systemd_service/
5. https://developer.hashicorp.com/terraform/install
6. https://shreedhar1998.hashnode.dev/automating-nginx-installation-and-application-deployment-across-multiple-servers-using-ansible-jenkins
7. https://unix.stackexchange.com/questions/227017/how-to-change-systemd-service-timeout-value
8. https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_systemd_unit_files_to_customize_and_optimize_your_system/assembly_working-with-systemd-unit-files_working-with-systemd
9. https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_patterns.html
10. https://github.com/futurice/terraform-examples
11. https://www.linuxtek.ca/2022/01/30/build-a-fully-functional-minecraft-server-in-less-than-10-minutes-with-ansible/
12. https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-create
