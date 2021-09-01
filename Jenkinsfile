pipeline{
    agent any
    environment{
          DEV_SERVER_IP='10.0.1.5'
        //   PROD_SERVER_IP='10.0.2.95'
          DIRECTION_API_KEY=credentials ('DIRECTION_API_KEY') 
          BUILD_VERSION='v1'
        }
    stages{
        stage("Check docker version"){
            steps{
                echo "========Verifying needed tools are available========"
                sh '''
                git --version
                docker --version
                '''
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
        stage("build docker image"){
            steps{
                echo "========Building docker image========"
                sh '''
                sudo docker build -t direction-dev:latest .
                '''
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
        // If versioning is required, you can prompt user to enter the version for tagging the image
        // stage("Prompt for Build Version"){
        //     steps{
        //         echo "====++++executing Prompt for Build Version++++===="
        //         script {
        //             env.DIRECTION_API_KEY='AIzaSyDXOazyJuyHIIbHEcVI4WxtAswxJIpJzRE'
        //     env.BUILD_VERSION = input message: 'Please enter the BUILD VERSION',
        //                         parameters: [string(defaultValue: '',
        //                                     description: '',
        //                                     name: 'Build_Version')]
        //             }
        //         echo "Build_Version: ${BUILD_VERSION}"
        //     }
        //     post{
        //         always{
        //             echo "====++++always++++===="
        //         }
        //         success{
        //             echo "====++++Prompt for Build Version executed successfully++++===="
        //         }
        //         failure{
        //             echo "====++++Prompt for Build Version execution failed++++===="
        //         }
        
        //     }
        // }
        stage("push docker image"){
            steps{
                echo "========tagging image========"
                sh 'sudo docker tag direction-dev:latest jakeni/direction-app:${BUILD_VERSION}'
                withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'pass', usernameVariable: 'user')]) {
                echo "pushing container to hub"
                sh '''
                sudo docker login -u jakeni -p $pass
                sudo docker push jakeni/direction-app:${BUILD_VERSION}
                sudo docker logout
                '''
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
        stage("deploy docker image to Dev"){
            steps{
                echo "Cleaning up before deployment"
                withCredentials([sshUserPrivateKey(credentialsId: 'ansible_ssh', keyFileVariable: '')]) {
                // sh 'ssh ec2-user@${DEV_SERVER_IP} sudo docker rm -f $(ssh ec2-user@${DEV_SERVER_IP} sudo docker ps -a -q)'
                sh 'ssh ec2-user@${DEV_SERVER_IP} sudo docker rm -f dir_app'
                echo "Deploying latest version"
                sh 'ssh ec2-user@${DEV_SERVER_IP} sudo docker run -p 8080:8080 -e loginname=joseph -e loginpass=pass -e api_key=${DIRECTION_API_KEY} --name dir_app -d jakeni/direction-app:${BUILD_VERSION} '
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
        stage("deploy docker image to Prod"){
            steps{
                echo "Cleaning up before deployment"
                withCredentials([sshUserPrivateKey(credentialsId: 'ansible_ssh', keyFileVariable: '')]) {
                // sh 'ssh ec2-user@${PROD_SERVER_IP} sudo docker rm -f $(ssh ec2-user@${PROD_SERVER_IP} sudo docker ps -a -q)'
                sh 'ssh ec2-user@${PROD_SERVER_IP} sudo docker rm -f dir_app'
                echo "Deployning latest version"
                sh 'ssh ec2-user@${PROD_SERVER_IP} sudo docker run -p 8080:8080 -e loginname=joseph -e loginpass=pass -e api_key=${DIRECTION_API_KEY} --name dir_app -d jakeni/direction-app:${BUILD_VERSION} '
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}