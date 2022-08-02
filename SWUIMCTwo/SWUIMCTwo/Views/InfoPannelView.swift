//
//  InfoPannelView.swift
//  SWUIMCTwo
//
//  Created by Mohan Chaudhari on 02/08/22.
//

import SwiftUI

struct InfoPannelView: View {

    var scale: CGFloat
    var offset: CGSize
    @State private var isInfoVisible: Bool = false

    var body: some View {
        HStack {

            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture {
                    withAnimation(.easeInOut) {
                        isInfoVisible.toggle()
                    }
                }

            Spacer()

            HStack (spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 15))
                Text("\(scale)")
                    .font(.system(size: 15))
                Spacer()

                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 15))
                Text("\(offset.width)")
                    .font(.system(size: 15))
                Spacer()

                Image(systemName: "arrow.up.and.down")
                    .font(.system(size: 15))
                Text("\(offset.height)")
                    .font(.system(size: 15))
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(width: 300)
            .opacity(isInfoVisible ? 1 : 0)

            Spacer()

        }
    }
}

struct InfoPannelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPannelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

