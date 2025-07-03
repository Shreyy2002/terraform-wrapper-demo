pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = 'true'
  }

  stages {
    stage('Init') {
      steps {
        sh 'chmod +x scripts/terraform-wrapper.sh'
        sh './scripts/terraform-wrapper.sh init'
      }
    }

    stage('Validate') {
      steps {
        sh './scripts/terraform-wrapper.sh validate'
      }
    }

    stage('Plan') {
      steps {
        sh './scripts/terraform-wrapper.sh plan'
      }
    }

    stage('Apply') {
      when {
        branch 'main'
      }
      steps {
        sh './scripts/terraform-wrapper.sh apply'
      }
    }

    stage('Destroy') {
      when {
        branch 'cleanup'
      }
      steps {
        sh './scripts/terraform-wrapper.sh destroy'
      }
    }
  }

  post {
    success {
      echo "✅ Terraform wrapper pipeline completed."
    }
    failure {
      echo "❌ Pipeline failed."
    }
  }
}
