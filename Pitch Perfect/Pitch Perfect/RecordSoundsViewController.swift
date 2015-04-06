//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Benedictus Widodo on 3/21/15.
//  Copyright (c) 2015 Benedictus Widodo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordInProgress: UILabel!
    @IBOutlet weak var stoppedButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Stopped, and Pause Button Initially hidden
        stoppedButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordButton.enabled = true
        resumeButton.enabled = false
        pauseButton.enabled = true
        recordInProgress.text = "Tap to Record"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        recordInProgress.text = "Recording"
        
        // Stopped Button will appear
        stoppedButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        
        // The microphone button is not enable after the first press
        recordButton.enabled = false
        
        //Record people Voice
        //Create a Path where the file will be saved
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Create the name of the file base on date and time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Open up an audioSession
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Create an instance of AVAudioRecorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        
        // Make RecordSoundsViewController is a delegate of AVAudioRecorder to be able to use some function of AVAudioRecorder like audioRecorderDidFinishRecording
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        // Start the recording
        audioRecorder.record()
        
        println("record in progress")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // Save the audio files
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            // Perform Seque to PlaySoundsViewController
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // Make sure the recordButton is enabled again if the recording not successfull
            println("Recording was not succesfull")
            recordButton.enabled = true
            stoppedButton.hidden = false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Past the data to PlaySoundsViewController
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func resumeAudio(sender: UIButton) {
        // Resume the Records
        audioRecorder.record()
        resumeButton.enabled = false
        pauseButton.enabled = true
        recordInProgress.text = "Recording"
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        // Pause the Records
        audioRecorder.pause()
        pauseButton.enabled = false
        resumeButton.enabled = true
        recordInProgress.text = "Paused"
    }
    
    
    @IBAction func stoppedAudio(sender: UIButton) {
        // Stop the records, close the audioSession, and hid the recordInProgress label
        recordInProgress.text = "Tap to Record"
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
}

