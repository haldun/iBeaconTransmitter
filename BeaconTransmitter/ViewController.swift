//
//  ViewController.swift
//  BeaconTransmitter
//
//  Created by Haldun Bayhantopcu on 11/09/15.
//  Copyright © 2015 monoid. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController {
    let uuid = NSUUID(UUIDString: "F34A1A1F-500F-48FB-AFAA-9584D641D7B1")!
    var beaconRegion: CLBeaconRegion!
    var peripheralManager: CBPeripheralManager!
    var isBroadcasting = false
    var dataDictionary = NSDictionary()
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    @IBAction func buttonTapped(sender: UIButton) {
        switchBroadcastingState()
    }
    
    func switchBroadcastingState() {
        if isBroadcasting {
            peripheralManager.stopAdvertising()
            button.setTitle("Start", forState: .Normal)
        } else {
            if peripheralManager.state == .PoweredOn {
                let major: CLBeaconMajorValue = UInt16(1)
                let minor: CLBeaconMinorValue = UInt16(3)
                beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: "co.monoid.hello")
                dataDictionary = beaconRegion.peripheralDataWithMeasuredPower(nil)
                peripheralManager.startAdvertising(dataDictionary as? [String : AnyObject])
                button.setTitle("Stop", forState: .Normal)
                isBroadcasting = true
            }
        }
    }
}

extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        var statusMessage = ""
        
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            statusMessage = "Bluetooth Status: Turned On"
            
        case CBPeripheralManagerState.PoweredOff:
            if isBroadcasting {
                switchBroadcastingState()
            }
            statusMessage = "Bluetooth Status: Turned Off"
            
        case CBPeripheralManagerState.Resetting:
            statusMessage = "Bluetooth Status: Resetting"
            
        case CBPeripheralManagerState.Unauthorized:
            statusMessage = "Bluetooth Status: Not Authorized"
            
        case CBPeripheralManagerState.Unsupported:
            statusMessage = "Bluetooth Status: Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: Unknown"
        }
        
        print(statusMessage)
    }
}

