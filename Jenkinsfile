pipeline {
    agent any

    environment {
        
        PATH = "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.gem/ruby/3.2.0/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Applications/Xcode.app/Contents/Developer/usr/bin"
        LANG = "en_US.UTF-8"
        LC_ALL = "en_US.UTF-8"
        SDKROOT = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
ASC_KEY_ID = credentials('ASC_KEY_ID')
    ASC_ISSUER_ID = credentials('ASC_ISSUER_ID')
    ASC_API_KEY_FILE = credentials('ASC_API_KEY_FILE')
    }

    stages {
        
        stage('Checkout Code') {
            steps {
                echo "Fetching latest code..."
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
                sh 'ruby -v'
                sh 'bundler -v || true'
                sh 'fastlane -v'
                echo "🧰 Tools verified!"
            }
        }

        stage('Install Dependencies (CI Minimal)') {
    steps {
        echo '📦 Skipping heavy gem dependencies for CI'
        sh 'bundle config set without "development test cocoa cocoapods"'
        sh 'bundle install || true'
        echo '📌 Gems installed (ignoring native build failures)'
    }
}


        stage('Build App (CI)') {
            steps {
                  echo "🚀 Building iOS app (no signing)..."
                sh 'bundle exec fastlane build_ci'
                echo "🎉 CI build complete"
            }
        }

        stage('Build Signed IPA') {
            steps {
                echo "🔐 Building signed IPA..."
                sh 'bundle exec fastlane ipa_local_signed'
                echo "🎉 Signed IPA generated!"
            }
        }

        stage('Archive IPA to Jenkins') {
            steps {
                echo "📦 Archiving IPA to Jenkins artifacts..."
                archiveArtifacts artifacts: '**/*.ipa', fingerprint: true
                echo "📌 IPA available in Jenkins build page"
            }
        }

stage('Upload to TestFlight') {
    steps {
        echo "🚀 Uploading to TestFlight..."
        sh 'bundle exec fastlane release'
    }
}


    }

    post {
        success {
            echo "🎯 SUCCESS: Build + Signed IPA complete 🚀"
        }
        failure {
            echo "❌ FAILURE: Check errors above"
        }
        always {
            echo "🔚 Pipeline finished"
        }
    }
}
