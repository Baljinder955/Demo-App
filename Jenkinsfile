pipeline {
    agent any

    environment {
        PATH = "$HOME/.rbenv/shims:$PATH"
        LANG = "en_US.UTF-8"
        LC_ALL = "en_US.UTF-8"
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
                sh 'ruby -v'
                sh 'bundler -v || gem install bundler -v 2.4.22'
                sh 'fastlane -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "📦 Installing gem dependencies..."
                sh 'bundle install --path vendor/bundle'
            }
        }

        stage('Build App (Unsigned)') {
            steps {
                echo "🚀 Running CI unsigned build..."
                sh 'bundle exec fastlane build_ci'
            }
        }

        stage('Build Signed IPA') {
            steps {
                echo "🔐 Building signed IPA..."
                sh 'bundle exec fastlane ci_signed'
            }
        }

        stage('Archive IPA to Jenkins') {
            steps {
                echo "📁 Archiving artifacts..."
                archiveArtifacts artifacts: 'build/**/*.ipa', fingerprint: true
            }
        }

    }

    post {
        success {
            echo "🎯 SUCCESS: CI build completed!"
        }
        failure {
            echo "❌ FAILURE: Check errors above."
        }
    }
}
