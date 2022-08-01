sudo su
sudo apt update -y

sudo apt install awscli -y

timestamp=$(date '+%d%m%Y-%H%M%S')
myname="Swati"


TARFILENAME="${myname}-httpd-logs-${timestamp}.tar"
S3BUCKETNAME="upgrad-swati"

#check if apache is installed
dpkg --get-selections | grep apache >> output.txt
if [ -s output.txt ]; then
        sudo apt-get install apache2 -y
fi

#check if apache is running
systemctl list-units --type=service --state=running >> output1.txt
if ! [ grep -q "apache2" output1.txt ]; then
        systemctl start apache2  
fi

#check if apache is enabled
systemctl list-unit-files | grep enabled >> output2.txt
if ! [ grep -q "apache2" output2.txt ]; then
        systemctl enable apache2
fi


cd ~
cd /tmp


#create a tar file in tmp directory archive to copy to s3 
tar -czvf ${TARFILENAME}.gz --exclude='*.tar' --exclude='*.zip' --absolute-names /var/log/apache2

#make sure to empty the apache2 log files
cd /var/log/apache2
> access.log
> error.log
> other_vhosts_access.log

#copy the tar file from tmp directory to s3
cd /tmp
aws s3 cp ${TARFILENAME}.gz s3://${S3BUCKETNAME}/


#remove the tar file from ec2 onec copied to s3
rm ${TARFILENAME}.gz






 
