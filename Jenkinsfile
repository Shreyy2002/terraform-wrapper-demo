pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = 'true'
  }

  stages {
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
      when { branch 'main' }
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh './scripts/terraform-wrapper.sh apply'
        }
      }
    }

    stage('Destroy') {
      when { branch 'cleanup' }
      steps {
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
