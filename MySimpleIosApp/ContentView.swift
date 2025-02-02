import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var text = "Hello, DevOps!"

    var textValue: String { text }  // ✅ Public getter for testing

    var body: some View {
        VStack {
            Text(text)
                .font(.title)
                .padding()

            Button(action: {
                text = "Button Clicked!"
            }) {
                Text("Click Me")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}


// Preview for Xcode UI rendering
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
