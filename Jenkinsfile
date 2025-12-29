pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DEVICE = "iPhone 16e"
        DESTINATION = "platform=iOS Simulator,name=iPhone 16e,OS=latest"
        DERIVED_DATA = "${WORKSPACE}/DerivedData"

        // 👇 Correct PATH extension for Jenkins (fixes your error)
        PATH+EXTRA = "/Users/baljindernetset/.gem/ruby/3.2.0/bin:/opt/homebrew/bin:/usr/local/bin"
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
                echo '🔍 Listing devices...'
                xcrun simctl list devices

                echo '📱 Booting $DEVICE...'
                xcrun simctl boot "$DEVICE" || true
                sleep 5

                echo '⏳ Waiting for boot status...'
                xcrun simctl bootstatus "$DEVICE" || true

                echo '📱 Simulator ready!'
                """
            }
        }

        stage("Install Dependencies") {
            steps {
                echo "📦 Checking for Podfile..."
                sh """
                if [ -f "Podfile" ]; then
                    echo '➡️ Podfile found. Running pod install...'
                    pod install
                else
                    echo '⚠️ No Podfile found — skipping.'
                fi
                """
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
                echo "🧪 Running test suite..."
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
                echo "🧪 Tests finished!"
            }
        }
    }

    post {
        success { echo "🎉 SUCCESS: Local CI build and tests completed!" }
        failure { echo "❌ ERROR: Pipeline failed — check logs above!" }
        always  { echo "🔚 Pipeline execution complete." }
    }
}
