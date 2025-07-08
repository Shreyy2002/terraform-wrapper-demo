@Library('shared-libraryy') _
import org.cloudninja.Wrapper  

def tf = new Wrapper(this)

pipeline {
    agent any

    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Check to destroy infrastructure')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Debug Branch') {
            steps {
                echo "Branch Info - BRANCH_NAME: ${env.BRANCH_NAME}, GIT_BRANCH: ${env.GIT_BRANCH}"
            }
        }

        stage('Init') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        tf.init()
                    }
                }
            }
        }

        stage('Validate') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        tf.validate()
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        tf.plan()
                    }
                }
            }
        }

        stage('Apply') {
            when {
                expression { env.BRANCH_NAME == 'main' || env.GIT_BRANCH == 'main' || env.GIT_BRANCH == 'origin/main' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        tf.apply()
                    }
                }
            }
        }

        stage('Destroy') {
            when {
                expression { params.DESTROY_INFRA }
            }
            steps {
                input message: "Are you sure you want to destroy the infrastructure?"
                withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        tf.destroy()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform pipeline completed successfully!"
        }
        failure {
            echo "❌ Terraform pipeline failed."
        }
    }
}
