pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DEVICE = "iPhone 16e"
        DESTINATION = "platform=iOS Simulator,name=iPhone 16e,OS=latest"
        DERIVED_DATA = "${WORKSPACE}/DerivedData"
    }

    stages {

        stage("Checkout Code") {
            steps {
                echo "📥 Checking out code from GitHub..."
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
                echo "✅ Code Checkout Done!"
            }
        }

        stage("Fix PATH for Jenkins") {
            steps {
                echo "🔧 Fixing PATH so xcpretty & brew work..."
                sh '''
                  export PATH="/Users/baljindernetset/.gem/ruby/3.2.0/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
                  which xcpretty || echo "🚨 xcpretty not found in PATH"
                  which xcodebuild || echo "🚨 xcodebuild not found in PATH"
                '''
            }
        }
        
        stage("Prepare Simulator") {
            steps {
                echo "📱 Preparing iOS Simulator..."
                sh """
                xcrun simctl list devices
                xcrun simctl boot "$DEVICE" || true
                sleep 5
                xcrun simctl bootstatus "$DEVICE" || true
                """
            }
        }

        stage("Install Dependencies") {
            steps {
                echo "📦 Checking Podfile..."
                sh """
                if [ -f Podfile ]; then pod install; fi
                """
            }
        }

        stage("Build App (No Signing)") {
            steps {
                echo "🔨 Building the app..."
                sh """
                export PATH="/Users/baljindernetset/.gem/ruby/3.2.0/bin:$PATH"
                xcodebuild -project "$PROJECT" -scheme "$SCHEME" -sdk iphonesimulator -destination "$DESTINATION" CODE_SIGNING_ALLOWED=NO clean build | xcpretty
                """
            }
        }

        stage("Run Tests") {
            steps {
                echo "🧪 Running tests..."
                sh """
                export PATH="/Users/baljindernetset/.gem/ruby/3.2.0/bin:$PATH"
                xcodebuild test -project "$PROJECT" -scheme "$SCHEME" -sdk iphonesimulator -destination "$DESTINATION" CODE_SIGNING_ALLOWED=NO | xcpretty
                """
            }
        }
    }

    post {
        success { echo "🎉 SUCCESS: Local CI OK!" }
        failure { echo "❌ ERROR: Pipeline failed — check logs!" }
        always  { echo "🔚 Pipeline done." }
    }
}
