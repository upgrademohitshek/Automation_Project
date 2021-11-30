name=Mohit
echo “ My name is $name”
sudo apt-get update -y
i=$(dpkg --get-selections |grep apache2)
if [[ $i == *"apache2    install"* ]]
then
        echo " Apache2 is alerady installed"
else
        apt-get install apache2
fi
astat=$(systemctl status apache2)
if [[ $astat == *"active (running)"* ]]
then
        echo "Apache2 is running"
else
        systemctl start apache2
fi
isapache2_enable=$(systemctl is-enabled apache2)
if [[ $isapache2_enable == "enabled" ]]
then
        echo " Apache2 is enabled"
else
        systemctl enable apache2
fi
tail -100 /var/log/apache2/access.log > access.log
tail -100 /var/log/apache2/error.log > error.log
t=$(date +'%d%m%Y-%H%M%S')
tar -cf Mohit-httpd-logs-$t.tar access.log error.log
mkdir tmp
mv Mohit-httpd-logs-$t.tar tmp
apt-get update
apt-get install awscli
s3_bucket=upgrad-mohit1
aws s3 cp /Automation_project/tmp/Mohit-httpd-logs-$t.tar s3://$s3_bucket
