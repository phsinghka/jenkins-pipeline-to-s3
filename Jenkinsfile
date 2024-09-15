pipeline {
    agent any
    environment {
        git_credential = "github-access"
        aws_credential = "AWS_CREDENTIALS"
        repo_url = "https://github.com/phsinghka/jenkins-pipeline-to-s3.git"
        bucket = "jenkins-s3-upload"
        region = "us-east-2"
        base_imagename = "maven-java-app"
        api_res_url = "https://${bucket}.s3.${region}.amazonaws.com/${TAG_NAME}/${app}-${TAG_NAME}.tar.gz"
    }
    tools {
        maven "maven-3.6.3"
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: "main",
                        credentialsId: "${git_credential}",
                        url: "http://${repo_url}"
                }
            }
        }
        stage('Maven Build') {
            steps {
                sh "mvn clean install"
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    docker.build("${base_imagename}")
                    sh "docker images"
                }
            }
        }
        stage('Zip Images') {
            steps {
                sh "mkdir ${TAG_NAME}"
                dir("${TAG_NAME}") {
                    sh "docker save ${base_imagename}:latest > ${base_imagename}-${TAG_NAME}.tar.gz"
                }
            }
        }
        stage('Upload to AWS S3') {
            steps {
                withAWS(region: "${region}", credentials: "${aws_credential}") {
                    s3Upload(file: "${TAG_NAME}", bucket: "${bucket}", path: "${TAG_NAME}/")
                }
            }
        }
        stage('Git Tag and Push') {
            steps {
                script {
                    datetime = new Date().format("yyyy-MM-dd HH:mm:ss")
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: "${git_credential}", usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD']]) {
                        sh "git tag -a ${TAG_NAME} -m '${datetime}'"
                        sh "git push http://${env.GIT_USERNAME}:${env.GIT_PASSWORD}@${repo_url} --tags"
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
            dir("${env.WORKSPACE}@tmp") { deleteDir() }
            dir("${env.WORKSPACE}@script") { deleteDir() }
            dir("${env.WORKSPACE}@script@tmp") { deleteDir() }
        }
    }
}
