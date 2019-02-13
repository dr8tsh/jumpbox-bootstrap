#!/bin/bash
set -e

sudo apt-get install -y -qq language-pack-en

echo ----------------
echo Installing jq...
echo ----------------
sudo apt-get -qq update
sudo apt-get -qq -y install jq

echo -----------------------
echo Installing Azure CLI...
echo -----------------------
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get -qq -y install apt-transport-https
sudo apt-get -qq update && sudo apt-get -y -qq install azure-cli

echo ----------------------
echo Installing Ruby 2.4...
echo ----------------------
sudo apt-add-repository ppa:brightbox/ruby-ng -y
sudo apt-get -y -qq update
sudo apt-get -y -qq install ruby2.4*
sudo apt-get -y -qq install ruby2.4 ruby2.4-dev
sudo apt-get -y -qq install build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3

echo ----------------------
echo Installing BOSH CLI...
echo ----------------------
curl -s https://api.github.com/repos/cloudfoundry/bosh-cli/releases/latest | jq -r ".assets[] | select(.name | contains(\"linux\")) | .browser_download_url" | wget -O bosh -i -
chmod +x bosh && sudo mv bosh /usr/local/bin

echo -------------------------
echo Installing cf cli/uaac...
echo -------------------------
sudo gem install cf-uaac
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get -y -qq update
sudo apt-get -y -qq install cf-cli
cf install-plugin -r CF-Community "top" -f
cf install-plugin -r CF-Community "drains" -f

echo ----------------------------
echo Installing Credhub Client...
echo ----------------------------
curl -s https://api.github.com/repos/cloudfoundry-incubator/credhub-cli/releases/latest | jq -r ".assets[] | select(.name | contains(\"linux\")) | .browser_download_url" | wget -O credhub.tgz -i -
tar -xvf credhub.tgz
sudo mv credhub /usr/local/bin

echo -----------------
echo Installing BBR...
echo -----------------
curl -s https://api.github.com/repos/cloudfoundry-incubator/bosh-backup-and-restore/releases/latest | jq -r ".assets[] | select(.name | contains(\"linux\")) | .browser_download_url" | wget -O bbr -i -
chmod +x bbr
sudo mv bbr /usr/local/bin

echo ---------------------
echo Installing OM Tool...
echo ---------------------
curl -s https://api.github.com/repos/pivotal-cf/om/releases/latest | jq -r ".assets[] | select(.name | contains(\"linux\")) | .browser_download_url" | wget -O om-linux -i -
chmod +x om-linux
sudo mv om-linux /usr/local/bin/om

echo ------------------------
echo Installing Pivnet CLI...
echo ------------------------
wget https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.55/pivnet-linux-amd64-0.0.55
sudo chmod +x pivnet-linux-amd64-0.0.55
sudo mv pivnet-linux-amd64-0.0.55 /usr/local/bin/pivnet

echo ---------------------
echo Installing acme.sh...
echo ---------------------
curl https://get.acme.sh | sh
source ~/.bashrc

echo --------------------
echo Updating .profile...
echo --------------------
cat >>~/.profile <<EOL
# PCF Env Vars
export SUBSCRIPTION_ID=""
export TENANT_ID=""
export CLIENT_ID=""
export CLIENT_SECRET=""
export LOCATION=
export RG_PCF=
export RG_CORE=
export OM_CLIENT_ID=
export OM_CLIENT_SECRET=
export OPSMGR_URL=
export BOSH_ENVIRONMENT=
export BOSH_CLIENT=
export BOSH_CLIENT_SECRET=
EOL


echo Complete!
