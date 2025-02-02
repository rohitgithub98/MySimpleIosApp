pipeline {
    agent any

    environment {
        APP_SCHEME = "MySimpleIosApp"
        APP_PROJECT = "MySimpleIosApp.xcodeproj"
        SIMULATOR_ID = "7D41B4B1-2119-48A5-9F5D-FC4334F2BD51"
        RUBY_VERSION = "3.2.2"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/rohitgithub98/MySimpleIosApp.git'
            }
        }

        stage('Setup Environment & Install Dependencies') {
            steps {
                sh '''
                set -e
                echo "📌 Using stable Ruby version"
                export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"
                export GEM_HOME="$HOME/.gem"
                export PATH="$GEM_HOME/bin:$PATH"

                echo "📌 Checking Ruby version"
                ruby -v

                echo "📌 Installing Bundler"
                gem install bundler --no-document || true

                echo "📌 Checking Fastlane"
                if ! command -v fastlane &> /dev/null
                then
                    echo "📌 Fastlane not found, installing..."
                    gem install fastlane -v 2.215.0 --no-document
                else
                    echo "✅ Fastlane already installed"
                fi

                echo "📌 Installing dependencies"
                bundle install

                echo "📌 Checking CocoaPods"
                if ! command -v pod &> /dev/null
                then
                    echo "📌 CocoaPods not found, installing..."
                    gem install cocoapods --no-document
                else
                    echo "✅ CocoaPods already installed"
                fi
                
                echo "📌 Running pod install"
                pod install || true
                '''
            }
        }

        stage('Boot Simulator') {
            steps {
                sh '''
                echo "📌 Shutting down and booting iOS Simulator"
                xcrun simctl shutdown all || true
                xcrun simctl boot ${SIMULATOR_ID}
                xcrun simctl list | grep Booted
                '''
            }
        }

        stage('Run Unit Tests') {
    steps {
        sh '''
        echo "📌 Ensuring Jenkins uses correct Ruby version"
        echo "📌 Using stable Ruby version"
        export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"
        export GEM_HOME="$HOME/.gem"
        export PATH="$GEM_HOME/bin:$PATH"
        
        echo "📌 Checking Bundler version"
        gem install bundler:2.6.2 --no-document || true
        bundle update --bundler
        
        echo "📌 Running Fastlane Unit Tests"
        bundle exec fastlane test || exit 1
        '''
    }
}


        stage('Build iOS App') {
            steps {
                sh '''
                echo "📌 Building iOS App"
                bundle exec fastlane build || exit 1
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                sh '''
                echo "📌 Archiving build artifacts"
                mkdir -p build
                '''
                archiveArtifacts artifacts: 'build/*.ipa', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build Successful!"
        }
        failure {
            echo "❌ Build Failed! Check logs for details."
        }
    }
}
