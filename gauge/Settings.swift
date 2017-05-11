//
//  Settings.swift
//  gauge
//
//  Created by Wojciech Ganczarski on 27/12/15.
//  Copyright © 2015 Sonic Scales. All rights reserved.
//

import Foundation
import CoreData

class Settings: NSManagedObject {
	
//	@NSManaged var gravitionalAcceleration: Double; // [m/s²]
	@NSManaged var density: Double; // [kg/m³]
	@NSManaged var stringDiameter: Double; // [1/1000 inch]
	@NSManaged var stringLength: Double; // [mm]
	@NSManaged var forceArmLength: Double; // [length unit]
	@NSManaged var resistanceArmLength: Double; // [length unit]

}
