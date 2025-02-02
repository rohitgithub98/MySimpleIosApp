pipeline {
    agent any

    environment {
        APP_SCHEME = "MySimpleIosApp"
        APP_PROJECT = "MySimpleIosApp.xcodeproj"
        SIMULATOR_ID = "7D41B4B1-2119-48A5-9F5D-FC4334F2BD51"
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
                set -e  # Fail immediately if any command fails
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
                
                echo "📌 Checking Ruby & Bundler"
                ruby -v
                which ruby
                which bundler
                
                echo "📌 Ensuring correct Fastlane & dependencies"
                gem install bundler --force --silent
                gem uninstall fastlane -a -x || true
                gem install fastlane -v 2.215.0 --no-document --silent
                gem install abbrev mutex_m highline commander --silent
                
                echo "📌 Installing Bundler dependencies"
                bundle install --path vendor/bundle
                
                echo "📌 Ensuring CocoaPods is installed"
                gem install cocoapods --silent
                
                echo "📌 Installing Pods"
                pod install
                '''
            }
        }

        stage('Boot Simulator') {
            steps {
                sh '''
                set -e
                echo "📌 Shutting down targeted simulator if running"
                xcrun simctl shutdown ${SIMULATOR_ID} || true

                echo "📌 Booting iOS Simulator"
                xcrun simctl boot ${SIMULATOR_ID}

                echo "📌 Verifying running Simulators"
                xcrun simctl list | grep "Booted"
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                set -e
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

                echo "📌 Running Fastlane Unit Tests"
                bundle exec fastlane test
                '''
            }
        }

        stage('Build iOS App') {
            steps {
                sh '''
                set -e
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

                echo "📌 Building iOS App"
                bundle exec fastlane build
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                sh '''
                echo "📌 Archiving Build Artifacts"
                mkdir -p build
                '''
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
            echo "📌 Fetching Last 50 Jenkins Logs"
            tail -n 50 ${WORKSPACE}/logs/*
            '''
        }
    }
}
