//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Benedictus Widodo on 3/23/15.
//  Copyright (c) 2015 Benedictus Widodo. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Get  the Passing the data from RecordsSoundsViewController
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        // Set enableRate to true to be able to change the rate later on
        audioPlayer.enableRate = true
        
        // Create an instance of AVAudioEngine and AVAudiofile object
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        // Play audioPlayer slowly
        playAudio(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Play audioPlayer really fast
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        // Play audio using Chipmunk Effect
        //playAudioWithVariablePitch(1000)
        var highPitch = AVAudioUnitTimePitch()
        highPitch.pitch = 1000
        playAudioWithEffect(highPitch)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // Play audio using Dartvader Effect
        //playAudioWithVariablePitch(-1000)
        var lowPitch = AVAudioUnitTimePitch()
        lowPitch.pitch = -1000
        playAudioWithEffect(lowPitch)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        // Play audio with echo Effect
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.8
        playAudioWithEffect(echoEffect)
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        // Play audio using Reverb Effect
        var reverbEffect = AVAudioUnitReverb()
        // Set the Effect to be inside cathedral
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50.0
        playAudioWithEffect(reverbEffect)
        
        
    }
    func playAudio(rate: Float){
        // Stop the audioPlayer and audioEngine to make sure the voice is not overlapping
        stopAndResetAudio()
        
        // set the rate and make sure the records play from the starts
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithEffect(effect: AVAudioNode){
        stopAndResetAudio()
        
        // Create an instance of AVAudioPlayerNode and attach to audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Create an instance of AVAudioUnitTimePitch and attach to audioEngine
        audioEngine.attachNode(effect)
        
        // Connect AudioPlayerNode to changePitchEffect
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        // Connect changePitchEffect to output(speaker)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // Play the records
        audioPlayerNode.play()
    }
    func stopAndResetAudio(){
        //Stop and Reset audioPlayer and audioEngine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    @IBAction func stoppedAudio(sender: UIButton) {
        // Stop the audioPlayer and audioEngine
        stopAndResetAudio()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
