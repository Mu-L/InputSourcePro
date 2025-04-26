import SwiftUI

struct EnhancedModeToggle: View {
    @EnvironmentObject var preferencesVM: PreferencesVM
    @EnvironmentObject var permissionsVM: PermissionsVM

    @State var isShowAccessibilityRequest = false

    var body: some View {
        let isDetectSpotlightLikeAppBinding = Binding(
            get: { preferencesVM.preferences.isEnhancedModeEnabled },
            set: { onNeedDetectSpotlightLikeApp($0) }
        )

        VStack(alignment: .leading) {
            HStack {
                Toggle("", isOn: isDetectSpotlightLikeAppBinding)
                    .sheet(isPresented: $isShowAccessibilityRequest) {
                        AccessibilityPermissionRequestView(isPresented: $isShowAccessibilityRequest)
                    }

                Text("Enhanced Mode".i18n())

                Spacer()
            }

            Text(.init("Enhanced Mode Description".i18n()))
                .font(.system(size: 12))
                .opacity(0.8)
        }
        .padding()
    }

    func onNeedDetectSpotlightLikeApp(_ isDetectSpotlightLikeApp: Bool) {
        preferencesVM.update {
            if isDetectSpotlightLikeApp {
                if permissionsVM.isAccessibilityEnabled {
                    $0.isEnhancedModeEnabled = true
                } else {
                    isShowAccessibilityRequest = true
                }
            } else {
                $0.isEnhancedModeEnabled = false
            }
        }
    }
}
