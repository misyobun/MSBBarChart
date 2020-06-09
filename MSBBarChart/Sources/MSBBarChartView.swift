//
//  MSBBarChartView.swift
//  MSBBarChart
//
//  Created by NaotoTakahashi.
//  Copyright © 2020 msb. All rights reserved.
//

import UIKit

public enum MSBBarChartViewOption {
    case space(CGFloat)
    case bottomSpace(CGFloat)
    case topSpace(CGFloat)
    case xAxisLabelColor(UIColor)
    case yAxisNumberOfInterval(Int)
    case yAxisTitle(String)
    case xAxisUnitLabel(String)
}

open class MSBBarChartView: UIView {

    open var assignmentOfColor: [Range<CGFloat>: UIColor] = [0.0..<0.25: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), 0.25..<0.50: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), 0.50..<0.75: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), 0.75..<1.0: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)] // デフォルト

    open var isHiddenLabelAboveBar: Bool = false
    
    var space: CGFloat = 12.0

    var topSpace: CGFloat = 40.0

    var bottomSpace: CGFloat = 40.0

    var xAxisLabelColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

    var yAxisNumberOfInterval: Int = 5

    var yAxisTitle: String = ""

    var xAxisUnitLabel: String = ""

    var dataEntries: [BarEntry]? = nil

    private let minimumBarWidth: CGFloat = 12.0

    private let startHorizontalLineX: CGFloat = 24.0

    private let mainLayer: CALayer = CALayer()

    private let scrollView: UIScrollView = UIScrollView()

    private let yAxisLabelWidth: CGFloat = 20.0

    private let yAxisMaxInterval: Int = 10

    private var maxYvalue: Int = 0

    private var widthBetweenZeroAndFirst: CGFloat = 16.0

    private var barWidth: CGFloat = 12.0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override open func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}

extension MSBBarChartView {

    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
    }

    private func showEntry(index: Int, entry: BarEntry, maxInterval: CGFloat) {
        let xPos: CGFloat = space + CGFloat(index) * (barWidth + space) + widthBetweenZeroAndFirst
        let yPos: CGFloat = translateHeightValueToYPosition(value: CGFloat(Int(entry.textValue)!) / CGFloat(maxYvalue))
        if !entry.isZeroBar() {
            drawBar(xPos: xPos, yPos: yPos, color: getBarColor(entry))
        }
        
        if !isHiddenLabelAboveBar {
            print("drawLabelAboveBar")
            drawBarValue(xPos: xPos - space / 2, yPos: yPos - space, textValue: entry.textValue, color: entry.color)
        }
        
        drawXLabel(xPos: xPos - space / 2, yPos: mainLayer.frame.height - bottomSpace + 10, title: entry.title, textColor: entry.textColor)
    }

    private func drawBar(xPos: CGFloat, yPos: CGFloat, color: UIColor) {
        let barLayer = CALayer()
        barLayer.cornerRadius = 4.0
        barLayer.frame = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
        barLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        barLayer.backgroundColor = color.cgColor
        mainLayer.addSublayer(barLayer)
        executeAnimation(xPos, yPos, color, barLayer)
    }

    private func executeAnimation(_ xPos: CGFloat, _ yPos: CGFloat, _ color: UIColor, _ layer: CALayer) {
        if yPos != mainLayer.frame.size.height - bottomSpace {
            let barLayerBase = CALayer()
            barLayerBase.frame = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
            barLayerBase.backgroundColor = color.cgColor
            barLayerBase.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            mainLayer.addSublayer(barLayerBase)
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.duration = 0.5
            animation.fromValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
            animation.toValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: -1 * (self.mainLayer.frame.height - self.bottomSpace - yPos) / 2)
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
            barLayerBase.add(animation, forKey: "bounds")
            barLayerBase.frame = animation.toValue as! CGRect
        }
        let subAnimation = CABasicAnimation(keyPath: "bounds")
        subAnimation.duration = 0.5
        subAnimation.fromValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
        subAnimation.toValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: -1 * (self.mainLayer.frame.height - self.bottomSpace - yPos))
        subAnimation.isRemovedOnCompletion = false
        subAnimation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        layer.add(subAnimation, forKey: "bounds")
        layer.frame = subAnimation.toValue as! CGRect
    }

    private func drawHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })

        let translatedHeight = CGFloat(1.0 / CGFloat(yAxisNumberOfInterval))
        var horizontalLineInfos: [Dictionary<String, CGFloat>] = []
        for i in 0...yAxisNumberOfInterval {
            let value = CGFloat(translatedHeight) * CGFloat(i)
            horizontalLineInfos.append(["value": value])
        }
        for lineInfo in horizontalLineInfos {
            let xPos = startHorizontalLineX
            let yPos = translateHeightValueToYPosition(value: (lineInfo["value"])!)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: scrollView.frame.size.width - space, y: yPos))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 0.5
            lineLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }

    private func drawVerticalAxisLabel(_ label: String, _ xPos: CGFloat, _ yPos: CGFloat) {
        let labelLayer = CATextLayer()
        labelLayer.frame = CGRect(x: xPos, y: yPos, width: yAxisLabelWidth, height: 16)
        labelLayer.string = "0"
        labelLayer.alignmentMode = CATextLayerAlignmentMode(rawValue: "right")
        labelLayer.fontSize = 8
        labelLayer.string = label
        labelLayer.contentsScale = UIScreen.main.scale
        labelLayer.foregroundColor = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)
        labelLayer.backgroundColor = UIColor.clear.cgColor
        mainLayer.addSublayer(labelLayer)
    }

    private func drawVericalAxisLabels() {
        guard let maxEntry = getMaxEntry() else { return }
        let yAxisLabels = createYAxisLabels(maxEntry: maxEntry)
        let translatedUnitHeight = CGFloat(1.0 / CGFloat(yAxisNumberOfInterval))
        drawVerticalAxisLabel("0", 0, mainLayer.frame.height - bottomSpace - 10)
        for (i, label) in yAxisLabels.enumerated() {
            let labelYPosi = translateHeightValueToYPosition(value: translatedUnitHeight * CGFloat(i + 1))
            drawVerticalAxisLabel(label, 0, labelYPosi - 6)
        }
        drawVerticalAxisLabel(yAxisTitle, 0, 20)
    }

    private func getMaxEntry() -> BarEntry? {
        guard let entries = self.dataEntries else { return nil }
        for entry in entries {
            if entry.isMax {
                return entry
            }
        }
        return nil
    }

    private func createYAxisLabels(maxEntry: BarEntry) -> [String] {
        let max = ((Int(maxEntry.textValue)! / yAxisMaxInterval) + 1) * 10
        maxYvalue = max
        let intervalValue = Int(max) / Int(yAxisNumberOfInterval)
        var insertValue: Int = 0
        var xAxisLabels: [String] = []
        while true {
            if insertValue >= max {
                return xAxisLabels
            }
            insertValue += intervalValue
            xAxisLabels.append(String(insertValue))
        }
    }

    private func drawBarValue(xPos: CGFloat, yPos: CGFloat, textValue: String, color: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth + space, height: 16)
        textLayer.foregroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 9
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }

    private func drawXLabel(xPos: CGFloat, yPos: CGFloat, title: String, textColor: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth + space, height: 16)
        textLayer.foregroundColor = textColor.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 9
        textLayer.string = title
        mainLayer.addSublayer(textLayer)
    }

    private func translateHeightValueToYPosition(value: CGFloat) -> CGFloat {
        let height: CGFloat = CGFloat(value) * (mainLayer.frame.height - bottomSpace - topSpace)
        return mainLayer.frame.height - bottomSpace - height
    }

    private func getBarColor(_ barEntity: BarEntry) -> UIColor {
        guard let maxBar = getMaxEntry() else { return UIColor.blue }
        let ratio = barEntity.height / maxBar.height
        let fetchLastAssignmentOfColor = assignmentOfColor.reversed()
        var barColor = fetchLastAssignmentOfColor.first?.value
        assignmentOfColor.keys.forEach { range in
            if (range.contains(ratio)) {
                barColor = assignmentOfColor[range] ?? barColor
            }
        }
        return barColor!
    }
}

extension MSBBarChartView {

    open func setOptions(_ options: [MSBBarChartViewOption]) {
        for option in options {
            switch (option) {
            case let .space(value):
                space = value
            case let .topSpace(value):
                topSpace = value
            case let .bottomSpace(value):
                bottomSpace = value
            case let .xAxisLabelColor(value):
                xAxisLabelColor = value
            case let .yAxisNumberOfInterval(value):
                yAxisNumberOfInterval = value
            case let .yAxisTitle(value):
                yAxisTitle = value
            case let .xAxisUnitLabel(value):
                xAxisUnitLabel = value
            }
        }
    }

    open func start() {
        guard let dataSource = self.dataEntries, let max = getMaxEntry(), let interval = Int(max.textValue) else { return }
        mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        barWidth = (scrollView.frame.width - (CGFloat(dataSource.count + 1) * space) - yAxisLabelWidth) / CGFloat(dataSource.count)
        if barWidth < minimumBarWidth {
           barWidth = minimumBarWidth
        }
        scrollView.contentSize = CGSize(width: (barWidth + space) * CGFloat(dataSource.count + 1), height: self.frame.size.height)
        mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        drawVericalAxisLabels()
        drawHorizontalLines()
        for i in 0..<dataSource.count {
            showEntry(index: i, entry: dataSource[i], maxInterval: CGFloat(interval))
        }
    }

    open func reset() {
        guard var dataSource = self.dataEntries else { return }
        dataSource.removeAll()
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        self.mainLayer.sublayers?.forEach({
            $0.removeFromSuperlayer()
        })
    }

    open func setDataEntries(values: [Int]) {
        guard let maxValue = values.max() else { return }
        var entries: [BarEntry] = []
        for i in 0..<values.count {
            let value = values[i]
            let height: CGFloat = CGFloat(value) / CGFloat(maxValue)
            let isMax = value == maxValue
            entries.append(BarEntry(color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), height: CGFloat(height), title: "\(i + 1)\(xAxisUnitLabel)", textValue: "\(value)", isMax: isMax, textColor: xAxisLabelColor))
        }
        self.dataEntries = entries
    }

    open func setXAxisUnitTitles(_ titles: [String]) {
        guard var entries = self.dataEntries else { return }
        for(index, var entry) in entries.enumerated() {
            entry.title = titles[index]
            entries[index] = entry
            if (index + 1 == titles.count) {
                break
            }
        }
        self.dataEntries = entries
    }

}

struct BarEntry {
    let color: UIColor
    let height: CGFloat
    var title: String
    let textValue: String
    let isMax: Bool
    let textColor: UIColor

    func isZeroBar() -> Bool {
        return height <= 0.0
    }
}

