pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DESTINATION = "platform=iOS Simulator,name=iPhone 14"
    }

    stages {

        stage("Checkout Code") {
            steps {
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
            }
        }

        stage("Install Dependencies") {
            steps {
                sh "pod install || true"     // ignore if no Podfile
            }
        }

        stage("Build App") {
            steps {
                sh """
                xcodebuild \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                -destination '$DESTINATION' \
                build
                """
            }
        }

        stage("Run Tests") {
            steps {
                sh """
                xcodebuild test \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                -destination '$DESTINATION'
                """
            }
        }
    }

    post {
        success { echo "🎉 Success: Demo App pipeline finished!" }
        failure { echo "❌ Pipeline failed — check the logs!" }
    }
}
