#!/bin/bash -l
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
                echo "📥 Checkout..."
                git branch: 'main', url: 'https://github.com/Baljinder955/Demo-App.git'
            }
        }

        stage("Build (No Signing)") {
            steps {
                echo "🔨 Simulator Build..."
                sh '''
                xcodebuild -project "$PROJECT" \
                -scheme "$SCHEME" \
                -sdk iphonesimulator \
                CODE_SIGNING_ALLOWED=NO clean build | xcpretty
                '''
            }
        }
    }

    post {
        always { echo "🔚 Done" }
    }
}
