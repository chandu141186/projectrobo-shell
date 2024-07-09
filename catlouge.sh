ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling Nodjs "

dnf module enable nodejs:18 -y  &>> $LOGFILE
VALIDATE $? "enabling Nodjs18 "

dnf install nodejs -y  &>> $LOGFILE
VALIDATE $? "Installing DNodejs "

useradd roboshop
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE

VALIDATE $? "Downloading catloguge application from url "

cd /app 

unzip /tmp/catalogue.zip  &>> $LOGFILE

VALIDATE $? "Unzipping Catalouge application"

cd /app

npm install &>> $LOGFILE

VALIDATE $? "Installing Depencies "

cp catlouge.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying Catlogue servises "


systemctl daemon-reload

VALIDATE $? "Reloding app "

systemctl enable catalogue

VALIDATE $? "Enabling Catalouge "

systemctl start catalogue

VALIDATE $? "Starting Catalouge "


dnf install mongodb-org-shell -y  &>> $LOGFILE

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &>> $LOGFILE