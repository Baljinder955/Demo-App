pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DESTINATION = "platform=iOS Simulator,name=iPhone 14"
        DERIVED_DATA = "${WORKSPACE}/DerivedData"
    }

    stages {

        stage("Checkout Code") {
            steps {
                echo "📥 Checking out code from GitHub repository..."
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
                echo "✅ Checkout complete!"
            }
        }


	stage("Prepare Simulator") {
    steps {
        echo "📱 Booting Simulator..."
        sh '''
        timeout 30 xcrun simctl boot "iPhone SE (2nd generation)" || true
        xcrun simctl bootstatus "iPhone SE (2nd generation)" --timeout 15 || true
        '''
    }
}

        stage("Install Dependencies") {
            steps {
                echo "📦 Installing Cocoapods (if Podfile exists)..."
                sh "pod install || true"    // won't fail if no Podfile
                echo "📦 Dependency installation DONE (or skipped)."
            }
        }

        stage("Build App (No Signing)") {
            steps {
                echo "🔨 Starting build process for $SCHEME ..."
                sh """
                xcodebuild \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                -destination '$DESTINATION' \
                -derivedDataPath "$DERIVED_DATA" \
                CODE_SIGNING_ALLOWED=NO \
                clean build
                """
                echo "🧱 Build complete!"
            }
        }

        stage("Run Tests") {
            steps {
                echo "🧪 Running tests on $DESTINATION ..."
                sh """
                xcodebuild test \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                -destination '$DESTINATION' \
                -derivedDataPath "$DERIVED_DATA" \
                CODE_SIGNING_ALLOWED=NO
                """
                echo "🧪 Tests finished!"
            }
        }
    }

    post {
        success {
            echo "🎉 SUCCESS: Demo App pipeline finished successfully!"
        }
        failure {
            echo "❌ FAILURE: Pipeline failed — please check above logs!"
        }
        always {
            echo "🔚 Pipeline completed (success or fail)."
        }
    }
}
