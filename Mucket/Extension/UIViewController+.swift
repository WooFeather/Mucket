//
//  UIViewController+.swift
//  Mucket
//
//  Created by 조우현 on 4/1/25.
//

import UIKit

extension UIViewController {
    
    /// 키보드가 올라오면 뷰를 올리는 메서드
    func enableKeyboardHandling(for scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        // 키보드 사라질 때 탭해서 dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }

    func disableKeyboardHandling() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let scrollView = findFirstScrollView(in: view),
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset + 16
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset + 16
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let scrollView = findFirstScrollView(in: view) else { return }
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func findFirstScrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }
        for subview in view.subviews {
            if let found = findFirstScrollView(in: subview) {
                return found
            }
        }
        return nil
    }
    
    func showAlert(title: String, message: String, button: String, style: UIAlertAction.Style = .default, isCancelButton: Bool = false  ,completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: button, style: style) { action in
            completionHandler()
        }
        
        if isCancelButton {
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel)
        }
        
        alert.addAction(button)
        
        present(alert, animated: true)
    }
}
