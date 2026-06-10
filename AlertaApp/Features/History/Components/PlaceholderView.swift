//
//  EmptyView.swift
//  AlertaApp
//
//  Created by Dimas Nugraha on 10/06/26.
//

import SwiftUI

enum PlaceholderStyle {
    case main
    case timeline

    var systemImage: String {
        switch self {
        case .main: "list.clipboard"
        case .timeline: "waveform"
        }
    }
    
    var systemImageSize: Font {
        switch self {
        case .main: Font.system(.largeTitle, weight: .semibold)
        case .timeline: Font.system(.largeTitle, weight: .semibold)
        }
    }

    var title: String {
        switch self {
        case .main: "Your session will appear here"
        case .timeline: "No alerts detected yet"
        }
    }
    
    var titleSize: AppTextStyle {
        switch self {
        case .main: .title3
        case .timeline: .body
        }
    }

    var subtitle: String {
        switch self {
        case .main: "Start a session to see your activity history"
        case .timeline: "We're actively monitoring your surroundings alerts will appear here when important sounds are detected"
        }
    }
    
    var subtitleSize: AppTextStyle {
        switch self {
        case .main: .body
        case .timeline: .caption1
        }
    }
}

struct PlaceholderView: View {
    var style: PlaceholderStyle = .main
    
    var body: some View {
        VStack{
            VStack(alignment: .center, spacing: 8) {
                VStack(alignment: .center, spacing: AppSpacing.medium) {
                    Image(systemName: style.systemImage)
                        .font(style.systemImageSize)
                        .soraFont(.headline, color: AppColors.primary)
                        .padding(AppSpacing.medium)
                        .background(AppColors.surfacePrimary)
                        .clipShape(Circle())
                }
                
                Text(style.title)
                    .soraFont(style.titleSize, emphasized: true)
                Text(style.subtitle)
                    .soraFont(style.subtitleSize, color: AppColors.textSecondary)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    PlaceholderView()
        .preferredColorScheme(.dark)
}
