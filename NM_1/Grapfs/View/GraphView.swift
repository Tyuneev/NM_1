//
//  GraphView.swift
//  NM_1
//
//  Created by Алексей Тюнеев on 04.09.2020.
//  Copyright © 2020 Алексей Тюнеев. All rights reserved.
//

import SwiftUI

struct GraphView: View {
    let graphs: Graphs
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                self.makeOX(geometry)
                self.makeOY(geometry)
                self.markOXY(geometry)
                self.addGraphs(geometry)
            }
        }.padding(.all, 10)
    }
    
    func makeOX(_ g: GeometryProxy) -> some View{
        return Path { path in
            let kX = Double(g.size.width)/(self.graphs.maxX - self.graphs.minX)
            let kY  = -Double(g.size.height)/(self.graphs.maxY - self.graphs.minY)
            path.addLines([
                CGPoint(x: (0.0), y: (0.0 - self.graphs.maxY) * kY),
                CGPoint(x: Double(g.size.width), y: (0.0 - self.graphs.maxY) * kY),
            ])
            path.addLines([
                CGPoint(x: Double(g.size.width)-20, y: (0.0-self.graphs.maxY)*kY - 8),
                CGPoint(x: Double(g.size.width), y: (0.0 - self.graphs.maxY) * kY),
                CGPoint(x: Double(g.size.width)-20, y: (0.0-self.graphs.maxY)*kY + 8),
            ])
            path.addLines([
                CGPoint(x: ((0.0 - self.graphs.minX) * kX - 3), y: (self.graphs.markOnY-self.graphs.maxY)*kY),
                CGPoint(x: ((0.0 - self.graphs.minX) * kX) + 3, y: (self.graphs.markOnY-self.graphs.maxY)*kY)
            ])
            
        }.stroke(lineWidth: 2)
    }
    func makeOY(_ g: GeometryProxy) -> some View{
        return Path { path in
            let kX = Double(g.size.width)/(self.graphs.maxX - self.graphs.minX)
            let kY  = -Double(g.size.height)/(self.graphs.maxY - self.graphs.minY)
            path.addLines([
                CGPoint(x: ((0.0 - self.graphs.minX) * kX), y: Double(g.size.height)),
                CGPoint( x: (0.0 - self.graphs.minX) * kX, y: (0.0))
            ])
            path.addLines([
                CGPoint(x: (0 - self.graphs.minX) * kX - 8, y: 20.0),
                CGPoint(x: (0 - self.graphs.minX) * kX, y: 0.0),
                CGPoint(x: (0 - self.graphs.minX) * kX + 8, y: 20.0)
            ])
            path.addLines([
                CGPoint(x: ((self.graphs.markOnX - self.graphs.minX) * kX),
                    y: (0 - self.graphs.maxY) * kY + 3),
                CGPoint( x: (self.graphs.markOnX  - self.graphs.minX) * kX, y: (0 - self.graphs.maxY) * kY - 3)
            ])
        }.stroke(lineWidth: 2)
    }
    func markOXY(_ g: GeometryProxy) -> some View {
        let kX = Double(g.size.width)/(self.graphs.maxX - self.graphs.minX)
        let kY  = -Double(g.size.height)/(self.graphs.maxY - self.graphs.minY)
        return ZStack {
            VStack{
                Spacer()
                    .frame(height: CGFloat(( self.graphs.maxY) * -kY + 10))
                HStack{
                    Spacer()
                        .frame(width: CGFloat((self.graphs.markOnX-self.graphs.minX)*kX - 10))
                        .layoutPriority(2)
                    Text(String(self.graphs.markOnX))
                        .layoutPriority(3)
                    Spacer()
                }
                Spacer()
            }.frame(width: g.size.width)
            VStack{
                Spacer()
                    .frame(height: CGFloat(( self.graphs.maxY) * -kY + 10))
                HStack{
                    Spacer()
                    Text("X")
                        .layoutPriority(3)
                }
                Spacer()
            }.frame(width: g.size.width)
            
        
            HStack(alignment: .top){
                Spacer()
                VStack(alignment: .trailing){
                    Text("Y")
                        .layoutPriority(2)
                    Spacer()
                }
                Spacer()
                    .frame(width: CGFloat(self.graphs.maxX*kX + 10))
            }.frame(height: g.size.height)
            
            HStack(alignment: .top){
                Spacer()
                VStack(alignment: .trailing){
                    Spacer()
                    Text("0")
                        .layoutPriority(2)
                    Spacer()
                        .frame(height: CGFloat((self.graphs.minY) * kY)-25)
                }
                Spacer()
                    .frame(width: CGFloat(self.graphs.maxX*kX + 10))
            }.frame(height: g.size.height)
            HStack(alignment: .bottom){
                VStack(alignment: .trailing){
                    Spacer()
                    Text(String(self.graphs.markOnY))
                        .lineLimit(1)
                        .layoutPriority(5)
                    Spacer()
                        .frame(height: CGFloat((self.graphs.minY - self.graphs.markOnY)*(kY)-10))
                        //.layoutPriority(2)
                }.frame(width: CGFloat(self.graphs.minX*(-kX) - 5))
                Spacer()
                    .frame(width: CGFloat(self.graphs.maxX*kX + 5))
            }.frame(height: g.size.height)
            
        }
    }
    func addGraphs(_ g: GeometryProxy) -> some View {
        let kX = Double(g.size.width)/(self.graphs.maxX - self.graphs.minX)
        let kY  = -Double(g.size.height)/(self.graphs.maxY - self.graphs.minY)
        return ForEach(self.graphs.graphs){ graph in
            Path { path in
                path.addLines(graph.points.map {
                        CGPoint(
                            x: ($0.0 - self.graphs.minX) * kX,
                            y: ($0.1 - self.graphs.maxY) * kY)})
            }.stroke(graph.color, lineWidth: 2)
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            GraphView(graphs: Graphs(graphs: [
//                Graph(function: {pow($0, 2.0)}, from: -2.0, to: 5.0, step: 0.1),
//                Graph(function: {-pow($0, 2.0) + 4.0}, from: -2.0, to: 5.0, step: 0.1),
//                Graph(function: {log($0)}, from: 0.1, to: 5, step: 0.1)], markOnX: 2.0, markOnY: 3)
//    //            Graph(interpolatePoints: [0.1, 0.5, 0.9, 1.3].map{($0,log($0))}, method: .lagrange, step: 0.1)], points:
//    //                [0.1, 0.5, 0.9, 1.3].map{Point(point: ($0,log($0)))}
//            )
            GraphView(graphs: Graphs(graphs: [
                                        Graph(function: {-3+$0+1/(1+$0)}, from: 0, to: 1, step: 0.1),], markOnX: 2.0, markOnY: 3)
                      //            Graph(interpolatePoints: [0.1, 0.5, 0.9, 1.3].map{($0,log($0))}, method: .lagrange, step: 0.1)], points:
                      //                [0.1, 0.5, 0.9, 1.3].map{Point(point: ($0,log($0)))}
            )
        }
    }
}

//{-3+$0+1/(1+$0)}
