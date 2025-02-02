pipeline {
    agent any

    environment {
        APP_SCHEME = "MySimpleIosApp"
        APP_PROJECT = "MySimpleIosApp.xcodeproj"
        SIMULATOR_ID = "7D41B4B1-2119-48A5-9F5D-FC4334F2BD51"
        GEM_HOME = "$HOME/.gem/ruby/3.4.0" // User-level gem installation
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
                set -e
                export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
                export PATH="$HOME/.gem/ruby/3.4.0/bin:$PATH"

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
                bundle config set path 'vendor/bundle'
                bundle install

                echo "📌 Ensuring CocoaPods is installed"
                gem install --user-install cocoapods
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
                export PATH="$HOME/.gem/ruby/3.4.0/bin:$PATH"

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
                export PATH="$HOME/.gem/ruby/3.4.0/bin:$PATH"

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
            tail -n 50 ${WORKSPACE}/logs/* || true
            '''
        }
    }
}
