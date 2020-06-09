import AppKit
import SwiftUI

// Delete this line if not using a playground
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        
        // if spacing is not set to zero, there will be a gap after the first row
        // this means that you'll see a gap between the top nav and the divider
        VStack(spacing: 0) {
            // I'm setting a frame with minHeight for the HStack height because
            // I don't have real content right now
            HStack {
                Text("This is the top nav if you like it")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(10)
            }.frame(maxWidth: 250, minHeight: 50)
             .background(Color.red)

            // Ensure to use frames() if you see gaps everywhere
            // or views not filling up height, then
            // setting a frame with maxWidth/maxHeight is the missing link
            SplitView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
    }
}

struct PaneView: View {
    @State var text: String
    
    var body: some View {
        HStack {
            Text("Hello \(text)")
                .padding(.vertical, 30)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
    }
}

struct SplitView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> NSViewController {
        let controller = SplitViewController()

        // I'm not sure if this has any impact
        // controller.view.frame = CGRect(origin: .zero, size: CGSize(width: 800, height: 800))
        return controller
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // nothing here
    }
}

class SplitViewController: NSSplitViewController {
    //TODO change this identifier
    private let splitViewResorationIdentifier = "com.company.restorationId:mainSplitViewController"

    // by "vc" I mean ViewController
    // I have two panes, so I have one vc for each
    var vcLeft = NSHostingController(rootView: PaneView(text: "sidebar"))
    var vcRight = NSHostingController(rootView: PaneView(text: "main content"))
    
    override func viewDidLoad() {
        // I use these for debugging if I have height issues
        // self.splitView.wantsLayer = true
        // self.splitView.layer?.backgroundColor = NSColor.blue.cgColor
        //
        // self.view.wantsLayer = true
        // self.view.layer?.backgroundColor = NSColor.green.cgColor
        //
        // self.view.autoresizingMask = [.width, .height]
        // self.splitView.autoresizingMask = [.width, .height]
        splitView.dividerStyle = .thin
        splitView.autosaveName = NSSplitView.AutosaveName(splitViewResorationIdentifier)
        splitView.identifier = NSUserInterfaceItemIdentifier(rawValue: splitViewResorationIdentifier)

        // I've set it to small values like 30 and 70 for the playground
        // For real world, set the minimum width for each pane
        // Else the pane will become fully collapsable
        vcLeft.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        vcRight.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 70).isActive = true

        let sidebarItem = NSSplitViewItem(viewController: vcLeft)
        sidebarItem.canCollapse = false

        // I'm not sure about this line. I've commented it out. Will explore later
        // sidebarItem.holdingPriority = NSLayoutConstraint.Priority(NSLayoutConstraint.Priority.defaultLow.rawValue + 1)
        addSplitViewItem(sidebarItem)

        let mainItem = NSSplitViewItem(viewController: vcRight)
        addSplitViewItem(mainItem)
        
        // feel free to add as many as subviews as required
    }
}

// Present the view in Playground
// Delete this line if not using a playground
PlaygroundPage.current.liveView = NSHostingController(rootView: ContentView())
