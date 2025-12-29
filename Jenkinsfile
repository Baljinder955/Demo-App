pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DERIVED_DATA = "${WORKSPACE}/DerivedData"
        PATH = "${env.PATH}:/Users/baljindernetset/.gem/ruby/3.2.0/bin:/opt/homebrew/bin:/usr/local/bin"
    }

    stages {

        stage("Checkout Code") {
            steps {
                echo "📥 Checking out code..."
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
                echo "🟢 Checkout complete!"
            }
        }

        stage("Build (Simulator - No Signing)") {
            steps {
                echo "🔨 Building for Simulator..."
                sh """
                xcodebuild \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                CODE_SIGNING_ALLOWED=NO \
                clean build | xcpretty
                """
                echo "🟣 Simulator build done!"
            }
        }

        stage("Archive (Unsigned IPA)") {
            steps {
                echo "📦 Archiving for IPA export (no signing)..."
                sh """
                xcodebuild \
                -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphoneos \
                -configuration Release \
                -archivePath "$WORKSPACE/build/$SCHEME.xcarchive" \
                CODE_SIGNING_ALLOWED=NO \
                CODE_SIGNING_REQUIRED=NO \
                CODE_SIGN_IDENTITY="" \
                archive | xcpretty
                """
            }
        }

        stage("Export IPA (Unsigned)") {
            steps {
                echo "📦 Exporting unsigned IPA..."
                sh """
                xcodebuild -exportArchive \
                -archivePath "$WORKSPACE/build/$SCHEME.xcarchive" \
                -exportPath "$WORKSPACE/build/ipa" \
                -exportOptionsPlist ExportOptions.plist \
                CODE_SIGNING_ALLOWED=NO | xcpretty
                """
                echo "🎉 Unsigned IPA created → build/ipa/"
            }
        }
    }

    post {
        success { echo "🎯 SUCCESS — Unsigned IPA Ready!" }
        failure { echo "❌ FAILED — Check logs!" }
        always { echo "🔚 Pipeline Completed" }
    }
}
