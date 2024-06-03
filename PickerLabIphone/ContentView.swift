import SwiftUI



struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    let names = [
        "bill", "john", "doe", "jim", "ludd-wig", "calvin", "talbot", "siri", "wayne", "garth", "mayo"]
    @State var name: String = "bill"
    @State var showingSheet = false
    
    var body: some View {
        Button(name) {
            showingSheet.toggle()
        }
        .accessibilityLabel("Name Picker")
        .sheet(isPresented: $showingSheet) {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                HStack(spacing: 0) {
                    Color.white
                }
                
                .cornerRadius(10)
                .padding([.leading, .trailing], 20)
                .padding(.top, 24)
                .ignoresSafeArea()
                
                
                VStack {
                    ValuePicker("Name", selection: $name) {
                        ForEach(names, id: \.self) { name in
                            Text(name)
                                .pickerTag(name)
                                .frame(height: 32)
                        }
                    }
                    .padding()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
        }
    }
}

#Preview {
    ContentView()
}


