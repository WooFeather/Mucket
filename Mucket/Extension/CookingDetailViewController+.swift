//
//  CookingDetailViewController+.swift
//  Mucket
//
//  Created by 조우현 on 4/5/25.
//

import SwiftUI
import SnapKit
import YouTubePlayerKit

extension CookingDetailViewController {
    func showYouTubeVideo(urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            cookingView.youtubePlayerContainerView.isHidden = true
            cookingView.emptyVideoView.isHidden = false
            cookingView.emptyVideoBackground.isHidden = false
            return
        }

        let player = YouTubePlayer(url: url)
        let playerView = YouTubePlayerView(player)
            .clipShape(RoundedRectangle(cornerRadius: 6))

        let hostingController = UIHostingController(rootView: playerView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let container = cookingView.youtubePlayerContainerView
        container.subviews.forEach { $0.removeFromSuperview() }
        container.addSubview(hostingController.view)
        hostingController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        hostingController.didMove(toParent: self)

        container.isHidden = false
        cookingView.emptyVideoView.isHidden = true
        cookingView.emptyVideoBackground.isHidden = true
    }
}
