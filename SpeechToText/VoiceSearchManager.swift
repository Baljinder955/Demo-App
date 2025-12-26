//
//  VoiceSearchManager.swift
//  SpeechToText
//
//  Created by Baljinder Netset on 24/12/25.
//

import Speech
import AVFoundation

final class VoiceSearchManager {
    
    static let shared = VoiceSearchManager()
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    // Callbacks
    var onPartialText: ((String) -> Void)?
    var onFinalText: ((String) -> Void)?
    var onListeningStateChanged: ((Bool) -> Void)?
    
    private init() {}
    
    // MARK: - Permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    // MARK: - Start Listening
    func startListening() {
        stopListening()
        onListeningStateChanged?(true)
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: format) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        recognitionTask = recognizer?.recognitionTask(
            with: recognitionRequest!
        ) { result, error in
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                
                if result.isFinal {
                    self.stopListening()
                    self.onFinalText?(text)
                } else {
                    self.onPartialText?(text)
                }
            }
            
            if error != nil {
                self.stopListening()
            }
        }
    }
    
    // MARK: - Stop
    func stopListening() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        
        onListeningStateChanged?(false)
    }
}
