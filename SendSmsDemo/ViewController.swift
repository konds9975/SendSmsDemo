//
//  ViewController.swift
//  SendSmsDemo
//
//  Created by Inkswipe on 5/18/18.
//  Copyright © 2018 Inkswipe. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreLocation
import Messages
import MessageUI
class ViewController: UIViewController,MFMessageComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let info = CTTelephonyNetworkInfo()
        let carrier = info.subscriberCellularProvider
        let mobileCountryCode = carrier?.mobileCountryCode
        let carrierName = carrier?.carrierName
        let isoCountryCode = carrier?.isoCountryCode
        let mobileNetworkCode = carrier?.mobileNetworkCode
        print("mobileCountryCode = \(mobileCountryCode ?? "NA") carrierName = \(carrierName ?? "NA") isoCountryCode = \(isoCountryCode ?? "NA") mobileNetworkCode = \(mobileNetworkCode ?? "NA")")
       // MFMessageComposeViewController ().addAttachmentURL(self.locationVCardURLFromCoordinate(coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 40))! as URL, withAlternateFilename: "vCard.loc.vcf")
    }

    func locationVCardURLFromCoordinate(coordinate: CLLocationCoordinate2D) -> NSURL?
    {
        guard let cachesPathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            print("Error: couldn't find the caches directory.")
            return nil
        }
        
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            print("Error: the supplied coordinate, \(coordinate), is not valid.")
            return nil
        }
         let vCardString = [
        "BEGIN:VCARD",
        "VERSION:3.0",
        "N:;Current Location;;;",
        "FN: Current Location",
        "item1.URL;type=pref:http://maps.apple.com/?ll=\(18.516726),\(73.856255)",
        "item1.X-ABLabel:_$!<HomePage>!$_",
        "item2.X-ABLabel:map url",
        "END:VCARD"
         ].joined(separator: "\n")
        /*
        let vCardString = [
            "BEGIN:VCARD",
            "VERSION:3.0",
            "N:;Shared Location;;;",
            "FN:Shared Location",
            "item1.URL;type=pref:http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)",
            "item1.X-ABLabel:map url",
            "END:VCARD"
            ].joined(separator: "\n")*/
        
        let vCardFilePath = (cachesPathString as NSString).appendingPathComponent("vCard.loc.vcf")
        
        do {
            try vCardString.write(toFile: vCardFilePath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error {
            print("Error, \(error), saving vCard: \(vCardString) to file path: \(vCardFilePath).")
        }
        return NSURL(fileURLWithPath: vCardFilePath)
    }

    
    func sendSMSText(phoneNumber: String) {
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
       
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
   
    @IBAction func sendSmsClick(_ sender: AnyObject) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
//            controller.body = "Emergency please help me"
//            controller.addAttachmentURL(self.locationVCardURLFromCoordinate(coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 40))! as URL, withAlternateFilename: "Current Location.loc.vcf")
            
           
           
            controller.body =  [
                "Emergency please help me",
                "http://maps.apple.com/?ll=\(18.516726),\(73.856255)",
                "Please click link to find patient"
              ].joined(separator: "\n")
            
            controller.recipients = ["9975465797","8888002996"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
   

}

