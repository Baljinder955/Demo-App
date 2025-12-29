pipeline {
    agent any

    environment {
        PROJECT = "SpeechToText.xcodeproj"
        SCHEME = "SpeechToText"
        DERIVED_DATA = "${WORKSPACE}/DerivedData"
        PATH+EXTRA = "/Users/baljindernetset/.gem/ruby/3.2.0/bin:/opt/homebrew/bin:/usr/local/bin"
    }

    stages {

        stage("Checkout Code") {
            steps {
                echo "📥 Checkout..."
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
            }
        }

        stage("Prepare Build Tools") {
            steps {
                echo "⚙️  Checking build dependencies..."
                sh '''
                    which xcodebuild
                    which xcpretty || gem install xcpretty
                '''
            }
        }

        stage("Build (No Signing)") {
            steps {
                echo "🔨 Simulator Build..."
                sh """
                    xcodebuild -project ${PROJECT} \
                    -scheme ${SCHEME} \
                    -sdk iphonesimulator \
                    -destination 'platform=iOS Simulator,name=iPhone 15' \
                    CODE_SIGNING_ALLOWED=NO \
                    clean build | xcpretty
                """
            }
        }
    }

    post {
        always { echo "🔚 Done ✔️" }
        success { echo "🎉 Build succeeded!" }
        failure { echo "❌ Build failed — check logs." }
    }
}
