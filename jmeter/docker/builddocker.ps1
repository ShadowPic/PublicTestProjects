docker build --tag="shadowpic/jmeter-base:latest" -f jmeterbase-docker .
docker push shadowpic/jmeter-base
docker build --tag="shadowpic/jmeter-master:latest" -f jmetermaster-docker .
docker build --tag="shadowpic/jmeter-slave:latest" -f jmeterslave-docker .
docker push shadowpic/jmeter-master
docker push shadowpic/jmeter-slave
