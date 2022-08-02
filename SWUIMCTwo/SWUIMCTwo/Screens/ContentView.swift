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


    fileprivate func resetImageScale() {
        withAnimation(.spring()) {
            imageOffset = .zero
            imageScale = 1
        }
    }

    fileprivate func zoomInImage() {
        withAnimation(.spring()) {
            if imageScale < 5 {
                imageScale = imageScale + 1
            }
        }
    }
    fileprivate func zoomOutImage() {
        withAnimation(.spring()) {
            if imageScale > 1 {
                imageScale = imageScale - 1
            }
        }
    }

    var body: some View {
        NavigationView{
            ZStack {
                Color.clear
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
                            resetImageScale()
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
                                    resetImageScale()
                                }
                            })
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    if value >= 1 && value <= 5 {
                                        imageScale = value
                                    } else if value > 5 {
                                        imageScale = 5
                                    } else if value < 1 {
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
            .overlay(
                InfoPannelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .onTapGesture(count: 2, perform: {
                        withAnimation(.spring()) {
                            imageOffset = .zero
                            imageScale = 1
                        }
                    })
                , alignment: .top
            )
            .overlay(
                Group{
                    HStack{
                        Button {
                            zoomInImage()
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                        }
                        .font(.system(size: 36))

                        Button {
                            resetImageScale()

                        } label: {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        .font(.system(size: 36))
                        Button {
                            zoomOutImage()
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                        }
                        .font(.system(size: 36))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
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
