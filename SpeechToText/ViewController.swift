//
//  ViewController.swift
//  SpeechToText
//
//  Created by Baljinder Netset on 24/12/25.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - UI Elements (Programmatic)
    private let micButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎙️", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 44)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Result"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap mic and speak"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupVoiceCallbacks()
        requestPermissions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(statusLabel)
        view.addSubview(micButton)
        view.addSubview(resultLabel)
        micButton.addTarget(self, action: #selector(micTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            micButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            micButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 80),
            micButton.heightAnchor.constraint(equalToConstant: 80),
            resultLabel.topAnchor.constraint(equalTo: micButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func requestPermissions() {
        VoiceSearchManager.shared.requestPermission { [weak self] granted in
            if !granted {
                DispatchQueue.main.async {
                    self?.statusLabel.text = "Permission denied"
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func micTapped() {
        VoiceSearchManager.shared.startListening()
    }
    
    private func setupVoiceCallbacks() {
        
        // LIVE text while speaking
        VoiceSearchManager.shared.onPartialText = { [weak self] text in
            DispatchQueue.main.async {
                debugPrint("Result:\(text)")
                self?.resultLabel.text = text
            }
        }
        
        // Final text after silence
        VoiceSearchManager.shared.onFinalText = { [weak self] text in
            DispatchQueue.main.async {
                self?.resultLabel.text = text
                self?.statusLabel.text = "Done"
                debugPrint("Result:\(text)")
                TextToSpeechManager.shared.speak(text: text)
            }
        }
        
        VoiceSearchManager.shared.onListeningStateChanged = { [weak self] listening in
            DispatchQueue.main.async {
                self?.statusLabel.text = listening ? "Listening…" : "Tap mic and speak"
                debugPrint("Result:\(listening)")
                self?.micButton.alpha = listening ? 0.5 : 1.0
            }
        }
    }
}
