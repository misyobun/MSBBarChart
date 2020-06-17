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
    case isHiddenLabelAboveBar(Bool)
    case isHiddenExceptBars(Bool)
    case isGradientBar(Bool)
}

open class MSBBarChartView: UIView {

    open var assignmentOfColor: [Range<CGFloat>: UIColor] = [0.0..<0.25: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), 0.25..<0.50: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), 0.50..<0.75: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), 0.75..<1.0: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)] // デフォルト

    open var assignmentOfGradient: [Range<CGFloat>: [UIColor]] = [0.0..<0.25: [#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)], 0.25..<0.50: [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)], 0.50..<0.75: [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)], 0.75..<1.0: [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]]

    var space: CGFloat = 12.0

    var topSpace: CGFloat = 40.0

    var bottomSpace: CGFloat = 40.0

    var xAxisLabelColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

    var yAxisNumberOfInterval: Int = 5

    var yAxisTitle: String = ""

    var xAxisUnitLabel: String = ""

    var dataEntries: [BarEntry]?
    
    private let bothSideMargin: CGFloat = 8.0

    private let minimumBarWidth: CGFloat = 12.0

    private let mainLayer: CAGradientLayer = CAGradientLayer()

    private let scrollView: UIScrollView = UIScrollView()

    private var yAxisLabelWidth: CGFloat = 0.0

    private let yAxisMaxInterval: Int = 10
    
    private let firstBarXpos: CGFloat = 28.0
    
    private let barValueBaseMargin: CGFloat = 12.0
    
    private var startHorizontalLineMargin: CGFloat = 4.0

    private var widthBetweenZeroAndFirst: CGFloat = 16.0

    private var barWidth: CGFloat = 12.0
    
    private var yAxisLabelFontSize: CGFloat = 8.0
    
    private var barLabelValueFontSize: CGFloat = 9.0
    
    private var isHiddenLabelAboveBar: Bool = false
    
    private var isHiddenExceptBars: Bool = false

    private var isGradientBar: Bool = false
    
    private var yAxisLabels:[String] = []

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
        guard let maxBar = getMaxEntry(), let entryValue = Float(entry.textValue), let maxEntryValue = Float(maxBar.textValue) else { return }
        
        let barWidthSet = barWidth + space
        let xPos: CGFloat = yAxisLabelWidth + bothSideMargin + CGFloat(index) * barWidthSet
        var yPos: CGFloat = mainLayer.frame.height - bottomSpace
        if (maxEntryValue > 0.0) {
            yPos = translateHeightValueToYPosition(value: CGFloat(entryValue / maxEntryValue))
        }
        
        if !entry.isZeroBar() {
             if isGradientBar {
                drawGradientBar(xPos: xPos, yPos: yPos, colors: getBarColors(entry))
            } else {
                drawBar(xPos: xPos, yPos: yPos, color: getBarColor(entry))
            }
        }
        
        if !isHiddenLabelAboveBar {
            drawBarValue(xPos: xPos - barValueBaseMargin / 2, yPos: yPos - barValueBaseMargin, textValue: entry.textValue, color: entry.color)
        }
        
        if !isHiddenExceptBars {
            drawXLabel(xPos: xPos - barValueBaseMargin / 2, yPos: mainLayer.frame.height - bottomSpace + 4.0, title: entry.title, textColor: entry.textColor)
        }
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
            barLayerBase.frame = animation.toValue as? CGRect ?? CGRect()
        }
        let subAnimation = CABasicAnimation(keyPath: "bounds")
        subAnimation.duration = 0.5
        subAnimation.fromValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
        subAnimation.toValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: -1 * (self.mainLayer.frame.height - self.bottomSpace - yPos))
        subAnimation.isRemovedOnCompletion = false
        subAnimation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        layer.add(subAnimation, forKey: "bounds")
        layer.frame = subAnimation.toValue as? CGRect ?? CGRect()
    }

    private func drawGradientBar(xPos: CGFloat, yPos: CGFloat, colors: [UIColor]) {
        let barLayer = CAGradientLayer()
        barLayer.cornerRadius = 4.0
        barLayer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        barLayer.frame = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
        barLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        let cgColors: [CGColor] = colors.map({ $0.cgColor })
        barLayer.colors = cgColors

        mainLayer.addSublayer(barLayer)
        executeGradientAnimation(xPos, yPos, colors, barLayer)
    }
    
    private func executeGradientAnimation(_ xPos: CGFloat, _ yPos: CGFloat, _ colors: [UIColor], _ layer: CAGradientLayer) {
        if yPos != mainLayer.frame.size.height - bottomSpace {
            let barLayerBase = CAGradientLayer()
            barLayerBase.frame = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
            barLayerBase.colors = colors
            barLayerBase.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            mainLayer.addSublayer(barLayerBase)
                        
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.duration = 0.5
            animation.fromValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
            animation.toValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: -1 * (self.mainLayer.frame.height - self.bottomSpace - yPos) / 2)
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
            barLayerBase.add(animation, forKey: "bounds")
            barLayerBase.frame = animation.toValue as? CGRect ?? CGRect()
        }
        let subAnimation = CABasicAnimation(keyPath: "bounds")
        subAnimation.duration = 0.5
        subAnimation.fromValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: 0)
        subAnimation.toValue = CGRect(x: xPos, y: self.mainLayer.frame.height - self.bottomSpace, width: self.barWidth, height: -1 * (self.mainLayer.frame.height - self.bottomSpace - yPos))
        subAnimation.isRemovedOnCompletion = false
        subAnimation.fillMode = CAMediaTimingFillMode(rawValue: "forwards")
        layer.add(subAnimation, forKey: "bounds")
        layer.frame = subAnimation.toValue as? CGRect ?? CGRect()
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
            let xPos = startHorizontalLineMargin + yAxisLabelWidth
            let yPos = translateHeightValueToYPosition(value: (lineInfo["value"])!)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: scrollView.contentSize.width, y: yPos))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 0.5
            lineLayer.strokeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            mainLayer.insertSublayer(lineLayer, at: 0)
        }
    }

    private func drawVerticalAxisLabel(_ label: String, _ xPos: CGFloat, _ yPos: CGFloat) {
        let labelLayer = CATextLayer()
        labelLayer.frame = CGRect(x: xPos, y: yPos, width: yAxisLabelWidth, height: 16)
        labelLayer.alignmentMode = CATextLayerAlignmentMode(rawValue: "right")
        labelLayer.fontSize = yAxisLabelFontSize
        labelLayer.string = label
        labelLayer.contentsScale = UIScreen.main.scale
        labelLayer.foregroundColor = #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1)
        labelLayer.backgroundColor = UIColor.clear.cgColor
        mainLayer.addSublayer(labelLayer)
    }
    
    private func setupYAxisLabels() {
         guard let maxEntry = getMaxEntry() else { return }
        self.yAxisLabels = createYAxisLabels(maxEntry: maxEntry)
        decideAxisLabelIfNeededWith(yAxisLabels)
    }

    private func drawVericalAxisLabels() {
        let translatedUnitHeight = CGFloat(1.0 / CGFloat(yAxisNumberOfInterval))
        drawVerticalAxisLabel("0", 0, mainLayer.frame.height - bottomSpace - 10)
        for (i, label) in self.yAxisLabels.enumerated() {
            let labelYPosi = translateHeightValueToYPosition(value: translatedUnitHeight * CGFloat(i + 1))
            drawVerticalAxisLabel(label, 0, labelYPosi - 6)
        }
        
        let labelsCount = self.yAxisLabels.count
        var yAxisTitleHeight:CGFloat = translateHeightValueToYPosition(value: 1.0) - 20
        if (labelsCount > 0) {
            yAxisTitleHeight = translateHeightValueToYPosition(value: translatedUnitHeight * CGFloat(labelsCount + 1)) - 6
        }
        drawVerticalAxisLabel(yAxisTitle, 0, yAxisTitleHeight)
    }
    
    private func decideAxisLabelIfNeededWith(_ yAxisLabels:[String]) {
        yAxisLabels.forEach { yAxisLabel in
            calcYaxisLabelMaxWidthIfNeeded(yAxisLabel)
        }
    }

    private func getMaxEntry() -> BarEntry? {
        guard let entries = self.dataEntries else { return nil }
        for entry in entries where entry.isMax {
            return entry
        }
        return nil
    }

    private func createYAxisLabels(maxEntry: BarEntry) -> [String] {
        guard let max = Float(maxEntry.textValue) else { return []}
        let intervalValue = max / Float(yAxisNumberOfInterval)
        var insertValue: Float = 0
        var yAxisLabels: [String] = []
        while true {
            if insertValue >= max {
                return yAxisLabels
            }
            insertValue += intervalValue
            yAxisLabels.append(String(format: "%.02f", Float(insertValue)))
        }
    }

    private func drawBarValue(xPos: CGFloat, yPos: CGFloat, textValue: String, color: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth + barValueBaseMargin, height: 16)
        textLayer.foregroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = barLabelValueFontSize
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }

    private func drawXLabel(xPos: CGFloat, yPos: CGFloat, title: String, textColor: UIColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: barWidth + barValueBaseMargin, height: 16)
        textLayer.foregroundColor = textColor.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = barLabelValueFontSize
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

    private func getBarColors(_ barEntity: BarEntry) -> [UIColor] {
        guard let maxBar = getMaxEntry() else { return [UIColor.blue] }
        let ratio = barEntity.height / maxBar.height
        let fetchLastAssignmentOfGradient = assignmentOfGradient.reversed()
        var barColors = fetchLastAssignmentOfGradient.first?.value
        assignmentOfGradient.keys.forEach { range in
            if (range.contains(ratio)) {
                barColors = assignmentOfGradient[range] ?? barColors
            }
        }
        return barColors!
    }
    
    private func calcYaxisLabelMaxWidthIfNeeded(_ label: String) {
        let size = label.size(withAttributes: [.font: UIFont.systemFont(ofSize: yAxisLabelFontSize)])
        if self.yAxisLabelWidth < size.width {
           self.yAxisLabelWidth = size.width
        }
    }
    
    private func prepareParameters() {
        self.yAxisLabelWidth = isHiddenExceptBars ? 0 : self.yAxisLabelWidth
        self.startHorizontalLineMargin = isHiddenExceptBars ? 0 : self.startHorizontalLineMargin
        self.bottomSpace = isHiddenExceptBars ? 0 : self.bottomSpace
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
                calcYaxisLabelMaxWidthIfNeeded(yAxisTitle)
            case let .xAxisUnitLabel(value):
                xAxisUnitLabel = value
            case let .isHiddenLabelAboveBar(value):
                isHiddenLabelAboveBar = value
            case let .isHiddenExceptBars(value):
                isHiddenExceptBars = value
            case let .isGradientBar(value):
                isGradientBar = value
            }
        }
    }

    open func start() {
        guard let dataSource = self.dataEntries, let max = getMaxEntry(), let interval = Int(max.textValue) else { return }
        mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        prepareParameters()
        setupYAxisLabels()
        
        barWidth = (scrollView.frame.width - (CGFloat(dataSource.count - 1) * space) - yAxisLabelWidth + startHorizontalLineMargin - bothSideMargin * 2) / CGFloat(dataSource.count)
        if barWidth < minimumBarWidth {
           barWidth = minimumBarWidth
        }
        
        let contentWidth = yAxisLabelWidth - startHorizontalLineMargin  + bothSideMargin + (barWidth + space) * CGFloat(dataSource.count - 1) + barWidth  + bothSideMargin
        scrollView.contentSize = CGSize(width:contentWidth , height: self.frame.size.height)
        mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
                
        if (!isHiddenExceptBars) {
            drawVericalAxisLabels()
            drawHorizontalLines()
        }

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
