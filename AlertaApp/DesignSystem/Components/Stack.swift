//
//  Stack.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 05/06/26.
//

import SwiftUI

let defaultHorizontalPadding: CGFloat = 0

struct Stack<Content: View>: View {
    enum Direction {
        case vertical, horizontal
    }

    enum JustifyContent {
        case start, center, end, spaceBetween, spaceAround
    }

    enum AlignItems {
        case leading, center, trailing, stretch
    }

    enum SizeMode: Equatable {
        case fill, fit, fixed(CGFloat)
    }

    private let direction: Direction
    private let justify: JustifyContent
    private let align: AlignItems
    private let spacing: CGFloat
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let width: SizeMode
    private let height: SizeMode
    private let content: Content

    init(
        direction: Direction = .vertical,
        justify: JustifyContent = .start,
        align: AlignItems = .leading,
        spacing: CGFloat = 0,
        horizontalPadding: CGFloat = defaultHorizontalPadding,
        verticalPadding: CGFloat = 0,
        width: SizeMode = .fit,
        height: SizeMode = .fit,
        @ViewBuilder content: () -> Content
    ) {
        self.direction = direction
        self.justify = justify
        self.align = align
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.width = width
        self.height = height
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        Group {
            switch direction {
            case .vertical:
                VStack(alignment: horizontalAlignment, spacing: stackSpacing) {
                    justifiedContent
                }
                .frame(
                    minWidth: resolveFrame(width).min,
                    idealWidth: resolveFrame(width).ideal,
                    maxWidth: resolveFrame(width).max,
                    minHeight: resolveFrame(height).min,
                    idealHeight: resolveFrame(height).ideal,
                    maxHeight: resolveFrame(height).max,
                    alignment: frameAlignment
                )

            case .horizontal:
                HStack(alignment: verticalAlignment, spacing: stackSpacing) {
                    justifiedContent
                }
                .frame(
                    minWidth: resolveFrame(width).min,
                    idealWidth: resolveFrame(width).ideal,
                    maxWidth: resolveFrame(width).max,
                    minHeight: resolveFrame(height).min,
                    idealHeight: resolveFrame(height).ideal,
                    maxHeight: resolveFrame(height).max,
                    alignment: frameAlignment
                )
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
    }

    // MARK: Justify Content

    @ViewBuilder
    private var justifiedContent: some View {
        switch justify {
        case .start:
            content
            if direction == .vertical, height == .fill {
                Spacer(minLength: 0)
            } else if direction == .horizontal, width == .fill {
                Spacer(minLength: 0)
            }

        case .center:
            Spacer(minLength: 0)
            content
            Spacer(minLength: 0)

        case .end:
            Spacer(minLength: 0)
            content

        // spaceBetween: children are spread out, first at start, last at end
        // We use the spacing from the stack + Spacers injected
        // between children via a custom modifier or rely on
        // the native behavior with frame expansion
        case .spaceBetween:
            content

        case .spaceAround:
            // spaceAround: equal space around each child
            Spacer(minLength: 0)
            content
            Spacer(minLength: 0)
        }
    }

    // MARK: - Computed Properties

    /// For spaceBetween/spaceAround, we don't pass custom spacing
    /// the Spacers handle distribution. Otherwise use the user's spacing
    private var stackSpacing: CGFloat {
        switch justify {
        case .spaceBetween: nil ?? spacing // Let spacers fill: use spacing as minimum
        case .spaceAround: spacing
        default: spacing
        }
    }

    /// Maps AlignItems to HorizontalAlignment (for VStack)
    private var horizontalAlignment: HorizontalAlignment {
        switch align {
        case .leading, .stretch: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }

    /// Maps AlignItems to VerticalAlignment (for HStack)
    private var verticalAlignment: VerticalAlignment {
        switch align {
        case .leading: .top
        case .center, .stretch: .center
        case .trailing: .bottom
        }
    }

    /// Maps the combination of justify + align to a single Alignment for the frame
    private var frameAlignment: Alignment {
        switch (direction, justify, align) {
        // Vertical direction
        case (.vertical, .start, .leading), (.vertical, .start, .stretch): .topLeading
        case (.vertical, .start, .center): .top
        case (.vertical, .start, .trailing): .topTrailing
        case (.vertical, .center, .leading), (.vertical, .center, .stretch): .leading
        case (.vertical, .center, .center): .center
        case (.vertical, .center, .trailing): .trailing
        case (.vertical, .end, .leading), (.vertical, .end, .stretch): .bottomLeading
        case (.vertical, .end, .center): .bottom
        case (.vertical, .end, .trailing): .bottomTrailing
        // Horizontal direction
        case (.horizontal, .start, .leading), (.horizontal, .start, .stretch): .topLeading
        case (.horizontal, .start, .center): .leading
        case (.horizontal, .start, .trailing): .bottomLeading
        case (.horizontal, .center, .leading), (.horizontal, .center, .stretch): .top
        case (.horizontal, .center, .center): .center
        case (.horizontal, .center, .trailing): .bottom
        case (.horizontal, .end, .leading), (.horizontal, .end, .stretch): .topTrailing
        case (.horizontal, .end, .center): .trailing
        case (.horizontal, .end, .trailing): .bottomTrailing
        // Default fallback
        case (.vertical, _, .leading), (.vertical, _, .stretch): .topLeading
        case (.vertical, _, .center): .top
        case (.vertical, _, .trailing): .topTrailing
        case (.horizontal, _, .leading), (.horizontal, _, .stretch): .topLeading
        case (.horizontal, _, .center): .leading
        case (.horizontal, _, .trailing): .bottomLeading
        }
    }

    private func resolveFrame(_ mode: SizeMode) -> (min: CGFloat?, ideal: CGFloat?, max: CGFloat?) {
        switch mode {
        case .fill: (nil, nil, .infinity)
        case .fit: (nil, nil, nil)
        case let .fixed(size): (size, size, size)
        }
    }
}

#Preview {
    Stack(
        direction: .horizontal,
        justify: .spaceBetween,
        align: .center,
        spacing: 2,
        width: .fill
    ) {
        Text("Hello")
        Spacer()
        Text("World")
    }
}
