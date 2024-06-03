import SwiftUI

public struct ValuePicker<SelectionValue: Hashable, Content: View>: View {
    private let title: LocalizedStringKey
    private let selection: Binding<SelectionValue>
    private let content: Content
    
    public init(
        _ title: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.selection = selection
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            _VariadicView.Tree(ValuePickerOptions(selectedValue: selection)) {
                content
            }
        }
        
    }
}

private struct ValuePickerOptions<Value: Hashable>: _VariadicView.MultiViewRoot {
    private let selectedValue: Binding<Value>
    
    init(selectedValue: Binding<Value>) {
        self.selectedValue = selectedValue
    }
    
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
            ForEach(children) { child in
                ValuePickerOption(
                    selectedValue: selectedValue,
                    value: child[CustomTagValueTraitKey<Value>.self]
                ) {
                    child
                }
            }
    }
}

private struct ValuePickerOption<Content: View, Value: Hashable>: View {
    @Environment(\.dismiss) private var dismiss
    
    private let selectedValue: Binding<Value>
    private let value: Value?
    private let content: Content
    
    init(
        selectedValue: Binding<Value>,
        value: CustomTagValueTraitKey<Value>.Value,
        @ViewBuilder _ content: () -> Content
    ) {
        self.selectedValue = selectedValue
        self.value = if case .tagged(let tag) = value {
            tag
        } else {
            nil
        }
        self.content = content()
    }
    
    var body: some View {
        Button(
            action: {
                withAnimation(Animation.easeIn) {
                    if let value {
                        selectedValue.wrappedValue = value
                    }
                } completion: {
                    dismiss()
                }
            },
            label: {
                HStack {
                        Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                            .font(.body.weight(.semibold))
                            .accessibilityHidden(true)
                            .opacity(isSelected ? 1 : 0)
                        
                    if (isSelected) {
                        content
                            .tint(.blue)
                    } else {
                        content
                            .tint(.primary)
                    }
                    Image(systemName: "checkmark").hidden()
                        
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            
            }
        )
        
    }
    
    private var isSelected: Bool {
        // How to determine whether that option is currently selected?
        selectedValue.wrappedValue == value
    }
}

extension View {
    public func pickerTag<V: Hashable>(_ tag: V) -> some View {
        _trait(CustomTagValueTraitKey<V>.self, .tagged(tag))
    }
}

private struct CustomTagValueTraitKey<V: Hashable>: _ViewTraitKey {
    enum Value {
        case untagged
        case tagged(V)
    }
    
    static var defaultValue: CustomTagValueTraitKey<V>.Value {
        .untagged
    }
}
