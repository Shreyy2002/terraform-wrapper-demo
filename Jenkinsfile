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
        script {
          echo "Detected BRANCH_NAME: ${env.BRANCH_NAME}"
          echo "Detected GIT_BRANCH: ${env.GIT_BRANCH}"
        }
      }
    }

    stage('Init') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh 'chmod +x scripts/terraform-wrapper.sh'
          sh './scripts/terraform-wrapper.sh init'
        }
      }
    }

    stage('Validate') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh './scripts/terraform-wrapper.sh validate'
        }
      }
    }

    stage('Plan') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh './scripts/terraform-wrapper.sh plan'
        }
      }
    }

    stage('Apply') {
      when {
        expression {
          env.BRANCH_NAME == 'main' || env.GIT_BRANCH == 'main' || env.GIT_BRANCH == 'origin/main'
        }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh './scripts/terraform-wrapper.sh apply'
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
          sh './scripts/terraform-wrapper.sh destroy'
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
