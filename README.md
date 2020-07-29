# maven-yarn-docker

Dockerfile defines docker image with jdk11, maven and yarn pre-installed. 

It expects pom.xml, yarn.lock and package.json to be located in the folder of Dockerfile. Dependencies are downloaded
 at image build time. 

Yarn dependencies are located at `/usr/src/yarn` folder
