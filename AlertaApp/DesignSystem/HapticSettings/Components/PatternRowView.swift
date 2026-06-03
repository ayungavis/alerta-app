//import SwiftUI
//
//struct SettRowView: View {
//    let title: String
//    let isSelected: Bool
//    let onSelect: () -> Void
//    let onPlay: () -> Void
//    
//    var body: some View {
//        HStack {
//            Rectangle()
//                .fill(AppColors.cyan)
//                .frame(width: 4)
//                .opacity(isSelected ? 1 : 0)
//            
//            Text(title)
//                .font(.system(size: 16))
//                .foregroundColor(.white)
//                .padding(.leading, 12)
//            
//            Spacer()
//            
//            if isSelected {
//                Image(systemName: "checkmark.circle.fill")
//                    .foregroundColor(AppColors.cyan)
//                    .font(.system(size: 20))
//                    .padding(.trailing, 16)
//                    .transition(.scale.combined(with: .opacity))
//            } else {
//                Image(systemName: "play.circle")
//                    .foregroundColor(AppColors.cyan)
//                    .font(.system(size: 20))
//                    .padding(.trailing, 16)
//                    .onTapGesture {
//                        onPlay()
//                    }
////                    .transition(.scale.combined(with: .opacity))
//            }
//        }
//        .frame(height: 64)
//        .background(AppColors.card)
//        .cornerRadius(12)
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .contentShape(Rectangle())
//        .onTapGesture {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                onSelect()
//            }
//        }
//    }
//}
