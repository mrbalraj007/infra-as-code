#!/bin/bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker azureuser
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# Commands to install Azcli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# Commands to install Terraform
sudo apt-get update
 # Add required dependencies for running EF Core commands
 sudo apt-get update
 sudo apt-get install -y libc6-dev
# Install .NET Core SDK if not already installed
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-7.0  # Adjust version as needed
# Install Entity Framework Core tools globally
dotnet tool install --global dotnet-ef --version 7.0.3

# Commands to install/reinstall the self-hosted agent

# Download the agent package (you might want to check for the latest version)
curl -o vsts-agent-linux-x64.tar.gz https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz

# Create the agent directory (or clear it if it exists)
if [ -d "myagent" ]; then
  echo "Agent directory 'myagent' exists. Removing..."
  sudo ./svc.sh stop  # Stop the service if it's running
  sudo ./svc.sh uninstall # Uninstall the service. Important to avoid issues.
  rm -rf myagent
fi
mkdir myagent

# Extract the agent
tar zxvf vsts-agent-linux-x64.tar.gz -C myagent

# Set permissions (be cautious with 777, consider more restrictive permissions)
chmod -R 777 myagent # Consider changing this. 777 is generally too open.

# Configure the agent
cd myagent

# Check if an agent with the same name exists and remove if it does
if [[ -d "_work/_tasks" && $(grep -q "aksagent" _work/_tasks/*/*/config.json) ]]; then
    echo "Agent 'aksagent' found in _work directory.  Removing..."
    # Stop and uninstall the agent if it's running (improve this section if needed)
    if [ -f ./svc.sh ]; then
        sudo ./svc.sh stop
        sudo ./svc.sh uninstall
    fi
    # Clean up the agent configuration files to avoid issues
    find . -name "config.json" -delete
    find . -name ".agent" -delete
    find . -name "_diag" -delete # Remove logs, potentially helpful for debugging
    find . -name "_work" -delete # Remove work directory
fi
./config.sh --unattended --url https://dev.azure.com/<Org ID> --auth pat --token <Token value> --pool Default --agent aksagent --acceptTeeEula

# Start the agent service
sudo ./svc.sh install
sudo ./svc.sh start

exit 0