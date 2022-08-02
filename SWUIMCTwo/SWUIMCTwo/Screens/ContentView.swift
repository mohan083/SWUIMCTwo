//
//  ContentView.swift
//  SWUIMCTwo
//
//  Created by Mohan Chaudhari on 29/07/22.
//

import SwiftUI

struct ContentView: View {

    @State private var isAnimating: Bool = false
    @State private var isDrawerOpen: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var pageIndex = 1

    let pages = pagesData

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
                Image(pages[pageIndex].imageName)
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
            .overlay(
                HStack {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    Spacer()

                    ForEach (pages){ item in
                        Image("thumb-\(item.imageName)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    isAnimating = true
                                    pageIndex = item.id - 1
                                    isDrawerOpen = false
                                    resetImageScale()
                                }
                            }
                    }
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 6, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                    , alignment: .topTrailing
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
