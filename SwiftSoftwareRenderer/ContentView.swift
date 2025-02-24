import SwiftUI
import AppKit

struct ContentView: View {
    static let xres: Int = 240
    static let yres: Int = 150

    @StateObject private var ch = ContentHandler()
    @State private var selectedView: ViewType = .basic
    @FocusState private var isImageFocused: Bool
    
    enum ViewType: Hashable {
        case basic, advanced, settings, tools
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $selectedView) {
                    NavigationLink(value: ViewType.basic) { Text("Basic Controls") }
                    NavigationLink(value: ViewType.advanced) { Text("Advanced Tools") }
                    NavigationLink(value: ViewType.settings) { Text("Display Settings") }
                    NavigationLink(value: ViewType.tools) { Text("Customization") }
                }
                .listStyle(.sidebar)
                .navigationSplitViewColumnWidth(200)

                // Projection Toggles at Bottom of Sidebar
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("3D Projection", isOn: $ch.is3DProjectionEnabled)
                        .toggleStyle(SwitchToggleStyle())
                    Toggle("2D Projection", isOn: $ch.is2DProjectionEnabled)
                        .toggleStyle(SwitchToggleStyle())
                    Toggle("2D Raycast Projection", isOn: $ch.is2DRaycastEnabled)
                        .toggleStyle(SwitchToggleStyle())
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
            }
        } content: {
            GeometryReader { geometry in
                ch.image
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(CGSize(width: Self.xres, height: Self.yres), contentMode: .fit)
                    .frame(
                        width: min(geometry.size.width, geometry.size.height * CGFloat(Self.xres)/CGFloat(Self.yres)),
                        height: min(geometry.size.height, geometry.size.width * CGFloat(Self.yres)/CGFloat(Self.xres))
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.windowBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
                    .focusable(true)
                    .focused($isImageFocused)
                    .onAppear {
                        isImageFocused = true
                    }
            }
        } detail: {
            NavigationStack {
                switch selectedView {
                case .basic:
                    InstructionsView(
                        title: "Basic Controls",
                        content: [
                            "↑↓ : Move Forward/Backward",
                            "←→ : Turn Left/Right",
                        
                        ]
                    )
                case .advanced:
                    ArticleView(
                        title: "",
                        content: """
                        The advanced tools section provides additional controls and features for power users. 
                        Here you can find options to fine-tune the application's behavior, configure custom shortcuts, 
                        and explore developer-focused utilities.
                        
                        Some of the features include:
                        - **Macro Support**: Automate tasks using custom scripts.
                        - **Extended Debugging**: Access detailed logs and analytics.
                        - **Custom Modifiers**: Adjust sensitivity, precision, and response curves.
                        
                        Use this section to optimize your experience!
                        """
                    )
                case .settings:
                    ArticleView(
                        title: "",
                        content: """
                        
                        """
                    )
                case .tools:
                    ArticleView(
                        title: "",
                        content: """
                        
                        """
                    )
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            ch.start()
          
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                ch.keyDown(event: event)
                return event
            }
            NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
                ch.keyUp(event: event)
                return event
            }
        }
    }
}

struct InstructionsView: View {
    let title: String
    let content: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(.title, design: .rounded))
                .fontWeight(.medium)
                .padding(.bottom, 8)

            ForEach(content, id: \.self) { item in
                Text(item)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
    }
}

struct ArticleView: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.medium)
                    .padding(.bottom, 8)
                
                Text(content)
                    .font(.system(.body))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
