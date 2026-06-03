struct SettingsMenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(AppColors.cyan.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundColor(AppColors.cyan)
                    .font(.system(size: 18))
            }
            .frame(width: 44)
            
            Text(title)
                .soraFont(size: 16, weight: .regular)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.cyan)
                .font(.system(size: 14, weight: .bold))
        }
        .padding(.horizontal, 16)
        .frame(height: 64)
        .background(AppColors.card)
        .cornerRadius(12)
    }
}
