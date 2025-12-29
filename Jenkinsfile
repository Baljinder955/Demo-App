pipeline {
    agent any

    environment {
        // Correct PATH for macOS + Xcode + Fastlane
        PATH = "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Xcode.app/Contents/Developer/usr/bin"
        LANG = "en_US.UTF-8"
        LC_ALL = "en_US.UTF-8"
        // Set SDK to avoid simulator or xcrun errors
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
                        credentialsId: 'Baljinder'   // Your Jenkins credential ID
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
                sh 'bundle install || true'   // skip if no Gemfile
                echo "📌 Dependencies OK!"
            }
        }

        stage('Build App (No Signing)') {
            steps {
                echo "🚀 Building iOS App (unsigned)..."
                sh 'fastlane build_nosign'
                echo "🎉 Build completed!"
            }
        }

        stage('Run Tests') {
            when {
                expression { false } // disabled for now – enable when ready
            }
            steps {
                echo "🧪 Tests skipped for now."
                // sh 'xcodebuild test ...'
            }
        }
    }

    post {
        success {
            echo "🎯 SUCCESS: Build finished without signing!"
        }
        failure {
            echo "❌ FAILURE: Check pipeline logs above."
        }
        always {
            echo "🔚 Pipeline finished."
        }
    }
}
