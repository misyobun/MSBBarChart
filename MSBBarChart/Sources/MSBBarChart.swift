//
//  MSBBarChart.swift
//  MSBBarChart
//
//  Created by Codex.
//  Copyright © 2026 msb. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct MSBBarChartEntry {
    public let value: Double
    public let title: String

    public init(value: Double, title: String) {
        self.value = value
        self.title = title
    }
}

@available(iOS 13.0, *)
public struct MSBBarChart: View {

    private let entries: [MSBBarChartEntry]

    private var assignmentOfColor: [Range<CGFloat>: Color] = [
        0.0..<0.25: Color(red: 0.129, green: 0.216, blue: 0.067),
        0.25..<0.50: Color(red: 0.196, green: 0.341, blue: 0.102),
        0.50..<0.75: Color(red: 0.275, green: 0.486, blue: 0.141),
        0.75..<1.0: Color(red: 0.341, green: 0.624, blue: 0.169)
    ]

    private var assignmentOfGradient: [Range<CGFloat>: [Color]] = [
        0.0..<0.25: [
            Color(red: 0.129, green: 0.216, blue: 0.067),
            Color(red: 0.196, green: 0.341, blue: 0.102)
        ],
        0.25..<0.50: [
            Color(red: 0.196, green: 0.341, blue: 0.102),
            Color(red: 0.275, green: 0.486, blue: 0.141)
        ],
        0.50..<0.75: [
            Color(red: 0.275, green: 0.486, blue: 0.141),
            Color(red: 0.341, green: 0.624, blue: 0.169)
        ],
        0.75..<1.0: [
            Color(red: 0.341, green: 0.624, blue: 0.169),
            Color(red: 0.467, green: 0.765, blue: 0.267)
        ]
    ]

    private var space: CGFloat = 12.0
    private var topSpace: CGFloat = 40.0
    private var bottomSpace: CGFloat = 40.0
    private var xAxisLabelColor: Color = Color(red: 0.502, green: 0.502, blue: 0.502)
    private var yAxisNumberOfInterval: Int = 5
    private var yAxisTitle: String = ""
    private var xAxisUnitLabel: String = ""
    private var isHiddenLabelAboveBar: Bool = false
    private var isHiddenExceptBars: Bool = false
    private var isGradientBar: Bool = false

    private let bothSideMargin: CGFloat = 8.0
    private let minimumBarWidth: CGFloat = 12.0
    private let startHorizontalLineMargin: CGFloat = 4.0
    private let yAxisLabelFontSize: CGFloat = 8.0
    private let barLabelValueFontSize: CGFloat = 9.0
    private let barCornerRadius: CGFloat = 4.0
    private let barValueBaseMargin: CGFloat = 12.0

    public init(values: [Int]) {
        self.entries = values.enumerated().map { index, value in
            MSBBarChartEntry(value: Double(value), title: "\(index + 1)")
        }
    }

    public init(values: [Double]) {
        self.entries = values.enumerated().map { index, value in
            MSBBarChartEntry(value: value, title: "\(index + 1)")
        }
    }

    public init(values: [Int], xAxisTitles: [String]) {
        self.entries = values.enumerated().map { index, value in
            let title = index < xAxisTitles.count ? xAxisTitles[index] : "\(index + 1)"
            return MSBBarChartEntry(value: Double(value), title: title)
        }
    }

    public init(values: [Double], xAxisTitles: [String]) {
        self.entries = values.enumerated().map { index, value in
            let title = index < xAxisTitles.count ? xAxisTitles[index] : "\(index + 1)"
            return MSBBarChartEntry(value: value, title: title)
        }
    }

    public init(entries: [MSBBarChartEntry]) {
        self.entries = entries
    }

    public var body: some View {
        GeometryReader { geometry in
            self.chart(in: geometry.size)
        }
    }
}

@available(iOS 13.0, *)
public extension MSBBarChart {

    func assignmentOfColor(_ assignment: [Range<CGFloat>: Color]) -> MSBBarChart {
        var chart = self
        chart.assignmentOfColor = assignment
        return chart
    }

    func assignmentOfGradient(_ assignment: [Range<CGFloat>: [Color]]) -> MSBBarChart {
        var chart = self
        chart.assignmentOfGradient = assignment
        return chart
    }

    func space(_ value: CGFloat) -> MSBBarChart {
        var chart = self
        chart.space = value
        return chart
    }

    func topSpace(_ value: CGFloat) -> MSBBarChart {
        var chart = self
        chart.topSpace = value
        return chart
    }

    func bottomSpace(_ value: CGFloat) -> MSBBarChart {
        var chart = self
        chart.bottomSpace = value
        return chart
    }

    func xAxisLabelColor(_ color: Color) -> MSBBarChart {
        var chart = self
        chart.xAxisLabelColor = color
        return chart
    }

    func yAxisNumberOfInterval(_ value: Int) -> MSBBarChart {
        var chart = self
        chart.yAxisNumberOfInterval = max(1, value)
        return chart
    }

    func yAxisTitle(_ value: String) -> MSBBarChart {
        var chart = self
        chart.yAxisTitle = value
        return chart
    }

    func xAxisUnitLabel(_ value: String) -> MSBBarChart {
        var chart = self
        chart.xAxisUnitLabel = value
        return chart
    }

    func hiddenLabelAboveBar(_ value: Bool) -> MSBBarChart {
        var chart = self
        chart.isHiddenLabelAboveBar = value
        return chart
    }

    func isHiddenLabelAboveBar(_ value: Bool) -> MSBBarChart {
        hiddenLabelAboveBar(value)
    }

    func hiddenExceptBars(_ value: Bool) -> MSBBarChart {
        var chart = self
        chart.isHiddenExceptBars = value
        return chart
    }

    func isHiddenExceptBars(_ value: Bool) -> MSBBarChart {
        hiddenExceptBars(value)
    }

    func gradientBar(_ value: Bool) -> MSBBarChart {
        var chart = self
        chart.isGradientBar = value
        return chart
    }

    func isGradientBar(_ value: Bool) -> MSBBarChart {
        gradientBar(value)
    }
}

@available(iOS 13.0, *)
private extension MSBBarChart {

    func chart(in size: CGSize) -> some View {
        let metrics = makeMetrics(in: size)

        return ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                if !isHiddenExceptBars {
                    horizontalLines(metrics: metrics)
                    yAxisLabels(metrics: metrics)
                }
                bars(metrics: metrics)
            }
            .frame(width: metrics.contentWidth, height: size.height, alignment: .topLeading)
        }
    }

    func horizontalLines(metrics: ChartMetrics) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(0...metrics.intervalCount, id: \.self) { index in
                Path { path in
                    let yPosition = metrics.yPosition(forRatio: CGFloat(index) / CGFloat(metrics.intervalCount))
                    path.move(to: CGPoint(x: metrics.gridStartX, y: yPosition))
                    path.addLine(to: CGPoint(x: metrics.contentWidth, y: yPosition))
                }
                .stroke(Color(red: 0.804, green: 0.804, blue: 0.804), lineWidth: 0.5)
            }
        }
    }

    func yAxisLabels(metrics: ChartMetrics) -> some View {
        ZStack(alignment: .topLeading) {
            Text("0")
                .font(.system(size: yAxisLabelFontSize))
                .foregroundColor(Color(red: 0.631, green: 0.631, blue: 0.631))
                .frame(width: metrics.yAxisLabelWidth, height: 16, alignment: .trailing)
                .position(x: metrics.yAxisLabelWidth / 2, y: metrics.zeroY - 2)

            ForEach(1...metrics.intervalCount, id: \.self) { index in
                Text(metrics.yAxisLabel(for: index))
                    .font(.system(size: yAxisLabelFontSize))
                    .foregroundColor(Color(red: 0.631, green: 0.631, blue: 0.631))
                    .frame(width: metrics.yAxisLabelWidth, height: 16, alignment: .trailing)
                    .position(
                        x: metrics.yAxisLabelWidth / 2,
                        y: metrics.yPosition(forRatio: CGFloat(index) / CGFloat(metrics.intervalCount)) + 2
                    )
            }

            if !yAxisTitle.isEmpty {
                Text(yAxisTitle)
                    .font(.system(size: yAxisLabelFontSize))
                    .foregroundColor(Color(red: 0.631, green: 0.631, blue: 0.631))
                    .frame(width: metrics.yAxisLabelWidth, height: 16, alignment: .trailing)
                    .position(x: metrics.yAxisLabelWidth / 2, y: metrics.topSpace - 12)
            }
        }
    }

    func bars(metrics: ChartMetrics) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(entries.indices, id: \.self) { index in
                self.bar(at: index, metrics: metrics)
            }
        }
    }

    func bar(at index: Int, metrics: ChartMetrics) -> some View {
        let entry = entries[index]
        let ratio = metrics.ratio(for: entry.value)
        let barHeight = max(0.0, metrics.chartHeight * ratio)
        let xPosition = metrics.barXPosition(at: index)
        let yPosition = metrics.zeroY - barHeight

        return ZStack(alignment: .topLeading) {
            if entry.value > 0 {
                barFill(for: ratio)
                    .clipShape(TopRoundedRectangle(radius: barCornerRadius))
                    .frame(width: metrics.barWidth, height: barHeight)
                    .position(x: xPosition + metrics.barWidth / 2, y: yPosition + barHeight / 2)
                    .animation(.easeOut(duration: 0.5), value: barHeight)
            }

            if !isHiddenLabelAboveBar {
                Text(metrics.valueLabel(for: entry.value))
                    .font(.system(size: barLabelValueFontSize))
                    .foregroundColor(Color(red: 0.059, green: 0.180, blue: 0.247))
                    .frame(width: metrics.barWidth + barValueBaseMargin, height: 16, alignment: .center)
                    .position(
                        x: xPosition + metrics.barWidth / 2,
                        y: max(metrics.topSpace - 8, yPosition - barValueBaseMargin + 8)
                    )
            }

            if !isHiddenExceptBars {
                Text("\(entry.title)\(xAxisUnitLabel)")
                    .font(.system(size: barLabelValueFontSize))
                    .foregroundColor(xAxisLabelColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(width: metrics.barWidth + barValueBaseMargin, height: 16, alignment: .center)
                    .position(
                        x: xPosition + metrics.barWidth / 2,
                        y: metrics.zeroY + 12
                    )
            }
        }
    }

    @ViewBuilder
    func barFill(for ratio: CGFloat) -> some View {
        if isGradientBar {
            LinearGradient(
                gradient: Gradient(colors: gradientColors(for: ratio)),
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            color(for: ratio)
        }
    }

    func makeMetrics(in size: CGSize) -> ChartMetrics {
        let maxValue = max(entries.map { $0.value }.max() ?? 0.0, 0.0)
        let effectiveTopSpace = topSpace
        let effectiveBottomSpace = isHiddenExceptBars ? 0.0 : bottomSpace
        let effectiveStartHorizontalLineMargin = isHiddenExceptBars ? 0.0 : startHorizontalLineMargin
        let effectiveYAxisLabelWidth = isHiddenExceptBars ? 0.0 : yAxisLabelWidth(maxValue: maxValue)
        let intervalCount = max(1, yAxisNumberOfInterval)
        let dataCount = max(1, entries.count)

        let availableWidth = max(0.0, size.width - (CGFloat(dataCount - 1) * space) - effectiveYAxisLabelWidth + effectiveStartHorizontalLineMargin - bothSideMargin * 2)
        let barWidth = max(minimumBarWidth, availableWidth / CGFloat(dataCount))
        let calculatedContentWidth = effectiveYAxisLabelWidth - effectiveStartHorizontalLineMargin + bothSideMargin + (barWidth + space) * CGFloat(dataCount - 1) + barWidth + bothSideMargin
        let contentWidth = max(size.width, calculatedContentWidth)
        let chartHeight = max(0.0, size.height - effectiveTopSpace - effectiveBottomSpace)

        return ChartMetrics(
            maxValue: maxValue,
            topSpace: effectiveTopSpace,
            bottomSpace: effectiveBottomSpace,
            yAxisLabelWidth: effectiveYAxisLabelWidth,
            startHorizontalLineMargin: effectiveStartHorizontalLineMargin,
            bothSideMargin: bothSideMargin,
            space: space,
            barWidth: barWidth,
            contentWidth: contentWidth,
            chartHeight: chartHeight,
            intervalCount: intervalCount
        )
    }

    func yAxisLabelWidth(maxValue: Double) -> CGFloat {
        let labels = (1...max(1, yAxisNumberOfInterval)).map { index -> String in
            let value = maxValue / Double(max(1, yAxisNumberOfInterval)) * Double(index)
            return String(format: "%.02f", value)
        } + [yAxisTitle]

        let maxLength = labels.map { $0.count }.max() ?? 1
        return max(CGFloat(maxLength) * yAxisLabelFontSize * 0.65, 8.0)
    }

    func color(for ratio: CGFloat) -> Color {
        return rangedValue(in: assignmentOfColor, ratio: ratio) ?? Color.blue
    }

    func gradientColors(for ratio: CGFloat) -> [Color] {
        return rangedValue(in: assignmentOfGradient, ratio: ratio) ?? [Color.blue]
    }

    func rangedValue<T>(in assignment: [Range<CGFloat>: T], ratio: CGFloat) -> T? {
        let sortedAssignment = assignment.sorted { left, right in
            left.key.lowerBound < right.key.lowerBound
        }
        if let match = sortedAssignment.first(where: { $0.key.contains(ratio) }) {
            return match.value
        }
        return sortedAssignment.last?.value
    }
}

@available(iOS 13.0, *)
private struct ChartMetrics {
    let maxValue: Double
    let topSpace: CGFloat
    let bottomSpace: CGFloat
    let yAxisLabelWidth: CGFloat
    let startHorizontalLineMargin: CGFloat
    let bothSideMargin: CGFloat
    let space: CGFloat
    let barWidth: CGFloat
    let contentWidth: CGFloat
    let chartHeight: CGFloat
    let intervalCount: Int

    var zeroY: CGFloat {
        return topSpace + chartHeight
    }

    var gridStartX: CGFloat {
        return startHorizontalLineMargin + yAxisLabelWidth
    }

    func ratio(for value: Double) -> CGFloat {
        guard maxValue > 0 else { return 0.0 }
        return CGFloat(value / maxValue)
    }

    func barXPosition(at index: Int) -> CGFloat {
        return yAxisLabelWidth + bothSideMargin + CGFloat(index) * (barWidth + space)
    }

    func yPosition(forRatio ratio: CGFloat) -> CGFloat {
        return zeroY - chartHeight * ratio
    }

    func yAxisLabel(for index: Int) -> String {
        guard maxValue > 0 else { return "0.00" }
        let value = maxValue / Double(intervalCount) * Double(index)
        return String(format: "%.02f", value)
    }

    func valueLabel(for value: Double) -> String {
        if value.rounded() == value {
            return "\(Int(value))"
        }
        return "\(value)"
    }
}

@available(iOS 13.0, *)
private struct TopRoundedRectangle: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius = min(radius, rect.width / 2, rect.height / 2)

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}
