//
//  TextToSpeechManager.swift
//  SpeechToText
//
//  Created by Baljinder Netset on 24/12/25.
//

import AVFoundation
import NaturalLanguage

final class TextToSpeechManager {

    static let shared = TextToSpeechManager()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    // MARK: - Public API (AUTO language detection)
    func speak(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let languageCode = detectLanguageCode(from: text)
        speak(text: text, languageCode: languageCode)
    }

    // MARK: - Core speak
    private func speak(text: String, languageCode: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = speechRate(for: languageCode)
        utterance.volume = 1.0
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
        
        synthesizer.speak(utterance)
    }

    // MARK: - Language Detection
    private func detectLanguageCode(from text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        guard let language = recognizer.dominantLanguage else {
            return "en-US"
        }
        return mapToSpeechLanguage(language)
    }

    // MARK: - Map NLP language → TTS language
    private func mapToSpeechLanguage(_ language: NLLanguage) -> String {
        switch language {
            
        case .english:
            return "en-US"
            
        case .punjabi:
            return "pa-IN"
            
        case .hindi:
            return "hi-IN"
            
        case .dutch:
            return "nl-NL"
            
        case .greek:
            return "el-GR"
            
        case .french:
            return "fr-FR"
            
        case .german:
            return "de-DE"
            
        case .spanish:
            return "es-ES"
            
        case .italian:
            return "it-IT"
            
        case .portuguese:
            return "pt-PT"
            
        case .arabic:
            return "ar-SA"
            
        default:
            return "en-US"
        }
    }

    // MARK: - Natural Speech Rates
    private func speechRate(for languageCode: String) -> Float {
        switch languageCode {
        case "pa-IN": return 0.44
        case "hi-IN": return 0.46
        case "ar-SA": return 0.45
        default: return 0.48
        }
    }
}
