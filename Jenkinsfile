pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DEVICE = "iPhone 16e"
        DESTINATION = "platform=iOS Simulator,name=iPhone 16e,OS=latest"
        DERIVED_DATA = "${WORKSPACE}/DerivedData"
        PATH = "/opt/homebrew/bin:/usr/local/bin:$PATH" // ensures pod & xcode tools found
    }

    stages {

        stage("Checkout Code") {
            steps {
                echo "📥 Checking out code from GitHub..."
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
                echo "✅ Code Checkout Done!"
            }
        }

        stage("Prepare Simulator") {
            steps {
                echo "📱 Preparing iOS Simulator..."
                sh """
                echo "🔍 Available simulators:"
                xcrun simctl list devices

                echo "📱 Booting $DEVICE ..."
                xcrun simctl boot "$DEVICE" || true
                sleep 5
                xcrun simctl bootstatus "$DEVICE" --timeout 20 || true
                echo "📱 Simulator ready!"
                """
            }
        }

        stage("Install Dependencies") {
            steps {
                echo "📦 Installing Pods (if Podfile exists)..."
                sh """
                if [ -f "Podfile" ]; then
                  echo "➡️ Podfile found — running pod install"
                  pod install
                else
                  echo "⚠️ No Podfile — skipping pod install"
                fi
                """
                echo "📦 Dependencies step finished!"
            }
        }

        stage("Build App (No Signing)") {
            steps {
                echo "🔨 Building the app..."
                sh """
                time xcodebuild \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                -destination "$DESTINATION" \
                -derivedDataPath "$DERIVED_DATA" \
                CODE_SIGNING_ALLOWED=NO \
                clean build | xcpretty
                """
                echo "🧱 App Build Success!"
            }
        }

        stage("Run Tests") {
            steps {
                echo "🧪 Running tests..."
                sh """
                time xcodebuild \
                test \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                -destination "$DESTINATION" \
                -derivedDataPath "$DERIVED_DATA" \
                CODE_SIGNING_ALLOWED=NO | xcpretty
                """
                echo "🧪 Test Stage Finished!"
            }
        }
    }

    post {
        success { echo "🎉 SUCCESS: Pipeline finished successfully!" }
        failure { echo "❌ ERROR: Pipeline failed — check logs!" }
        always  { echo "🔚 Pipeline execution complete." }
    }
}
