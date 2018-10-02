//
//  tvos_scummvmviewcontroller.swift
//  ScummVM-tvOS
//
//  Created by Jonny Bergstrom on 2018/10/02.
//

import UIKit

class tvOSScummVMViewController: UIViewController {
	override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		print("pressesBegan presses: \(presses), event: \(String(describing: event))")
		
		let handled: Bool
		
		handled = false
		
		if !handled {
			super.pressesBegan(presses, with: event)
		}
	}
}
