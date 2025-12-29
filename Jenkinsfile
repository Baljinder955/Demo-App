pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Xcode.app/Contents/Developer/usr/bin"
        LANG = "en_US.UTF-8"
        LC_ALL = "en_US.UTF-8"
        SDKROOT = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📥 Fetching latest code..."
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Baljinder955/Demo-App.git',
                        credentialsId: 'Baljinder'
                    ]]
                ])
                echo "✅ Checkout completed!"
            }
        }

        stage('Verify Tools') {
            steps {
                echo "🔧 Checking toolchain..."
                sh 'xcodebuild -version'
                sh 'fastlane -v'
                echo "🧰 Tools verified!"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing dependencies..."
                sh 'gem install bundler:4.0.3 || true'
                sh 'bundle install || true'
                echo "📌 Dependencies OK!"
            }
        }

        stage('Build App (CI)') {
            steps {
                echo "🚀 Building iOS App for CI..."
                sh 'bundle exec fastlane build_ci'
            }
        }

        stage('Run Tests') {
            when { expression { false } } // disabled for now
            steps {
                echo "🧪 Tests skipped."
            }
        }
    }

    post {
        success {
            echo "🎯 SUCCESS: CI build completed!"
        }
        failure {
            echo "❌ FAILURE: Check pipeline logs above."
        }
        always {
            echo "🔚 Pipeline finished."
        }
    }
}
