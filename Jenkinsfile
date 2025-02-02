pipeline {
    agent any

    environment {
        APP_SCHEME = "MySimpleIosApp"
        APP_PROJECT = "MySimpleIosApp.xcodeproj"
        SIMULATOR_ID = "7D41B4B1-2119-48A5-9F5D-FC4334F2BD51"  // Ensure simulator UDID is set correctly
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/rohitgithub98/MySimpleIosApp.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
                ruby -v
                which ruby
                which bundler
                gem install bundler --force
                bundle install
                pod install
                '''
            }
        }

        stage('Boot Simulator') {
            steps {
                sh '''
                xcrun simctl shutdown all
                xcrun simctl boot ${SIMULATOR_ID}
                xcrun simctl list | grep "Booted"
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
                bundle exec fastlane test
                '''
            }
        }

        stage('Build iOS App') {
            steps {
                sh '''
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
                bundle exec fastlane build
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                sh 'mkdir -p build' // Ensure the folder exists
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
            sh '''
            tail -n 50 /Users/vijayraghavan/.jenkins/logs/*
            xcrun simctl list | grep "Booted"
            '''
        }
    }
}
