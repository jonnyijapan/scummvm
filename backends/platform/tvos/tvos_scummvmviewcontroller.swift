//
//  tvos_scummvmviewcontroller.swift
//  ScummVM-tvOS
//
//  Created by Jonny Bergstrom on 2018/10/02.
//

import UIKit

@objc protocol Protocol_tvosscummvmviewcontroller: class {
	func press(button: AppleTVRemoteButton)
	func release(button: AppleTVRemoteButton)
	func cancel(button: AppleTVRemoteButton)
}

class tvOSScummVMViewController: UIViewController {
	
//	@objc enum Button: Int {
//		case primary
//		case secondary
//		case menu
//	}
	
	weak var delegate: Protocol_tvosscummvmviewcontroller?
	
	@objc convenience init(delegate: Protocol_tvosscummvmviewcontroller) {
		self.init()
		self.delegate = delegate
	}
	
	override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		guard let d = self.delegate, let button = tvOSScummVMViewController.fetchButton(from: event) else {
			super.pressesBegan(presses, with: event)
			return
		}
		d.press(button: button)
	}

	override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		guard let d = self.delegate, let button = tvOSScummVMViewController.fetchButton(from: event) else {
			super.pressesEnded(presses, with: event)
			return
		}
		d.release(button: button)
	}
	
	override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		guard let d = self.delegate, let button = tvOSScummVMViewController.fetchButton(from: event) else {
			super.pressesEnded(presses, with: event)
			return
		}
		d.cancel(button: button)
	}
}

private extension tvOSScummVMViewController {
	static func fetchButton(from event: UIPressesEvent?) -> AppleTVRemoteButton? {
		let button: AppleTVRemoteButton?
		
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
				button = .menu
				break
			case .playPause:
				button = .secondary
				break
			}
		}
		else {
			button = nil
		}
		
		return button
	}
}
