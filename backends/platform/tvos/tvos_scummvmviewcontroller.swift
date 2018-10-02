//
//  tvos_scummvmviewcontroller.swift
//  ScummVM-tvOS
//
//  Created by Jonny Bergstrom on 2018/10/02.
//

import UIKit

@objc protocol Protocol_tvosscummvmviewcontroller: class {
	func press(button: tvOSScummVMViewController.Button)
}

class tvOSScummVMViewController: UIViewController {
	
	@objc enum Button: Int {
		case primary
		case secondary
	}
	
	weak var delegate: Protocol_tvosscummvmviewcontroller?
	
	@objc convenience init(delegate: Protocol_tvosscummvmviewcontroller) {
		self.init()
		self.delegate = delegate
	}
	
	override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		//print("pressesBegan presses: \(presses), event: \(String(describing: event))")
		
		let button: Button?
		
		if let event = event, let press = event.allPresses.first {
			switch press.type {
			case .upArrow:
				button = nil
				break
			case .downArrow:
				button = nil
				break
			case .leftArrow:
				button = nil
				break
			case .rightArrow:
				button = nil
				break
			case .select:
				// Main button
				button = .primary
				break
			case .menu:
				button = nil
				break
			case .playPause:
				button = .secondary
				break
			}
		}
		else {
			button = nil
		}
	
		if let button = button {
			self.delegate?.press(button: button)
		}
		else {
			super.pressesBegan(presses, with: event)
		}
	}
}
