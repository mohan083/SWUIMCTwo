//
//  ContentView.swift
//  SWUIMCTwo
//
//  Created by Mohan Chaudhari on 29/07/22.
//

import SwiftUI

struct ContentView: View {

    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero

    var body: some View {
        NavigationView{
            ZStack {
                Image("magazine-front-cover")
                    .resizable()
                //                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.5), radius: 12, x: 2, y:20)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            withAnimation(.spring()) {
                                imageOffset = .zero
                                imageScale = 1
                            }
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            })

                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    withAnimation(.spring()) {
                                        imageOffset = .zero
                                        imageScale = 1
                                    }
                                }
                            })
                    )

            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
