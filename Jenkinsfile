pipeline {
    agent any

    environment {
        APP_SCHEME = "MySimpleIosApp"
        APP_PROJECT = "MySimpleIosApp.xcodeproj"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/rohitgithub98/MySimpleIosApp.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'bundle install || true'
                sh 'pod install || true'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'fastlane test'
            }
        }

        stage('Build iOS App') {
            steps {
                sh 'fastlane build'
            }
        }

        stage('Archive Artifacts') {
            steps {
                sh 'mkdir -p build' //Ensure folder exists
                archiveArtifacts artifacts: 'build/MySimpleIosApp.ipa', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build Successful!"
        }
        failure {
            echo "❌ Build Failed! Check logs for details."
            sh 'tail -n 50 ~/Library/Logs/Jenkins.log' //Print the last 50 lines of Jenkins logs
        }
    }
}

