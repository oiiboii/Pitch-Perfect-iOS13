import Foundation

struct K{
    
    //ui views identifier names
    struct Views{
        static let modulatorVC = "recToMod"
    }
    
    //ui text labels content
    struct TextLabels{
        static  let preRecordingStatus = "Tap to Record"
        static let whileRecordingStatus = "Recording in progress..."
    }
    
    //file
    struct Files{
        static let recordingFileName = "recordingVoice.wav"
    }
    
    //debugging error messages
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
}
