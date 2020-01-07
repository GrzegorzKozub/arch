set -e -o verbose

# aws

sudo curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
sudo chmod +x /usr/local/bin/ecs-cli

if [ ! -d ~/.aws ]; then mkdir ~/.aws; fi
if [ ! -d ~/.ecs ]; then mkdir ~/.ecs; fi

cp `dirname $0`/home/greg/.aws/config ~/.aws

cp -r /mnt/.arch/keys/aws/credentials ~/.aws

