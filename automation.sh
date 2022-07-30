sudo su
sudo apt update -y

sudo apt install awscli -y

timestamp=$(date '+%d%m%Y-%H%M%S')


TARFILENAME="Swati-httpd-logs-${timestamp}.tar"
S3BUCKETNAME="upgrad-swati"

dpkg --get-selections | grep apache >> output.txt

if [ -s output.txt ]; then
        sudo apt-get install apache2 -y
fi

systemctl start apache2
systemctl enable apache2

cd /var/log/apache2/

mkdir -p tmp
cd tmp

timestamp=$(date '+%d%m%Y-%H%M%S')

TARFILENAME="Swati-httpd-logs-${timestamp}.tar"


$ tar -czvf tmp/${TARFILENAME}.gz --exclude='*.tar' --exclude='*.zip' --absolute-names /apache2

cd ..

> access.log
> error.log
> other_vhosts_access.log

cd tmp

aws s3 cp ${TARFILENAME}.gz s3://${S3BUCKETNAME}/

rm ${TARFILENAME}.gz
 
 
