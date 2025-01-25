//
//  AudioExpenseAdderViewModel.swift
//  XTracker
//
//  Created by HSSN on 16/01/2025.
//

import Foundation
import Speech

class AudioExpenseAdderViewModel: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false

    func startRecording() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer not available")
            return
        }

        // Prepare audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
            return
        }

        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request")
            return
        }
        recognitionRequest.shouldReportPartialResults = true

        // Attach audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            recognitionRequest.append(buffer)
        }

        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start: \(error.localizedDescription)")
            return
        }

        // Start recognition task
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                self?.recognizedText = result.bestTranscription.formattedString
            }

            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                self?.stopRecording()
            }
        }

        isRecording = true
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }

}

