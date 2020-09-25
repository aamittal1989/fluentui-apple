//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class NotificationViewDemoController: DemoController {
    enum Variant: Int, CaseIterable {
        case primaryToast
        case primaryToastWithImageAndTitle
        case neutralToast
        case primaryBar
        case primaryOutlineBar
        case neutralBar
        case persistentBarWithAction
        case persistentBarWithCancel
        case neutralToastWithImageAndTitle

        var displayText: String {
            switch self {
            case .primaryToast:
                return "Primary Toast with auto-hide"
            case .primaryToastWithImageAndTitle:
                return "Primary Toast with image and title"
            case .neutralToast:
                return "Neutral Toast"
            case .primaryBar:
                return "Primary Bar"
            case .primaryOutlineBar:
                return "Primary Outline Bar"
            case .neutralBar:
                return "Neutral Bar"
            case .persistentBarWithAction:
                return "Persistent Bar with Action"
            case .persistentBarWithCancel:
                return "Persistent Bar with Cancel"
            case .neutralToastWithImageAndTitle:
                return "Neutral Toast with no padding custom image"
            }
        }

        var delayForHiding: TimeInterval {
            switch self {
            case .primaryToast, .primaryBar, .primaryOutlineBar, .neutralBar:
                return 2
            default:
                return .infinity
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.surfaceSecondary

        for (index, variant) in Variant.allCases.enumerated() {
            if index > 0 {
                // spacers
                container.addArrangedSubview(UIView())
                container.addArrangedSubview(UIView())
            }
            addTitle(text: variant.displayText)
            container.addArrangedSubview(createNotificationView(forVariant: variant))
            container.addArrangedSubview(createButton(title: "Show", action: #selector(showNotificationView)))
            container.alignment = .leading
        }
    }

    private func createNotificationView(forVariant variant: Variant) -> NotificationView {
        let view = NotificationView()
        switch variant {
        case .primaryToast:
            view.setup(style: .primaryToast, message: "Mail Archived", actionTitle: "Undo", action: { [unowned self] in self.showMessage("`Undo` tapped") })
        case .primaryToastWithImageAndTitle:
            view.setup(style: .primaryToast, title: "Kat's iPhoneX", message: "Listen to Emails • 7 mins", image: UIImage(named: "play-in-circle-24x24"), action: { [unowned self] in self.showMessage("`Dismiss` tapped") }, messageAction: { [unowned self] in self.showMessage("`Listen to emails` tapped") })
        case .neutralToast:
            view.setup(style: .neutralToast, message: "Some items require you to sign in to view them", actionTitle: "Sign in", action: { [unowned self] in self.showMessage("`Sign in` tapped") })
        case .primaryBar:
            view.setup(style: .primaryBar, message: "Updating...")
        case .primaryOutlineBar:
            view.setup(style: .primaryOutlineBar, message: "Mail Sent")
        case .neutralBar:
            view.setup(style: .neutralBar, message: "No internet connection")
        case .persistentBarWithAction:
            view.setup(style: .neutralBar, message: "This error can be taken action on with the action on the right.", actionTitle: "Action", action: { [unowned self] in self.showMessage("`Action` tapped") })
        case .persistentBarWithCancel:
            view.setup(style: .neutralBar, message: "This error can be tapped or dismissed with the icon to the right.", action: { [unowned self] in self.showMessage("`Dismiss` tapped") })
        case .neutralToastWithImageAndTitle:
            view.setup(style: .neutralToast, title: "Screenshot Found", message: "Tap to edit, convert, share and more", image: resizeImage(image: UIImage(named: "avatar_allan_munger"), newWidth: 64, newHeight: 64)?.withRenderingMode(.alwaysOriginal), action: { [unowned self] in self.showMessage("`Dismiss` tapped") }, messageAction: { [unowned self] in self.showMessage("`Screenshot notification` tapped") }, hasNoImagePadding: true)
        }
        return view
    }

    @objc private func showNotificationView(sender: UIButton) {
        guard let index = container.arrangedSubviews.filter({ $0 is UIButton }).firstIndex(of: sender), let variant = Variant(rawValue: index) else {
            preconditionFailure("showNotificationView is used for a button in the wrong container")
        }

        createNotificationView(forVariant: variant).show(in: view) { $0.hide(after: variant.delayForHiding) }
    }

    func resizeImage(image: UIImage?, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image?.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
