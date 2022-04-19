import SwiftUI
import Kingfisher

public struct CatalystImage: View {
    
    private let url: URL
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        KFImage(url)
            .resizable(resizingMode: .stretch)
            .aspectRatio(contentMode: .fill)
    }
}

//extension CatalystImage {
//    public func resizable(resizingMode: Image.ResizingMode = .tile) -> some View {
//        
//        modifier(CatalystImageModifier())
//    }
//}
//
//
//struct CatalystImageModifier: ViewModifier {
//   
//    func body(content: CatalystImage) -> CatalystImage {
//        content
//            .resizable(resizingMode: .stretch)
//            .aspectRatio(contentMode: .fill)
//            
//            
//    }
//    
//    
//}
