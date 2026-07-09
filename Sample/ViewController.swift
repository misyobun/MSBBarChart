//
//  ViewController.swift
//  Sample
//
//  Created by NaotoTakahashi
//  Copyright © 2020 msb. All rights reserved.
//

import UIKit
import SwiftUI
import MSBBarChart

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }

    private func setupMenu() {
        title = "MSBBarChart Sample"
        view.backgroundColor = .systemBackground
        view.subviews.forEach { $0.removeFromSuperview() }

        let titleLabel = UILabel()
        titleLabel.text = "MSBBarChart"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Choose a sample to preview"
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center

        let uiKitButton = makeMenuButton(title: "Preview UIKit")
        uiKitButton.addTarget(self, action: #selector(showUIKitSample), for: .touchUpInside)

        let swiftUIButton = makeMenuButton(title: "Preview SwiftUI")
        swiftUIButton.addTarget(self, action: #selector(showSwiftUISample), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            uiKitButton,
            swiftUIButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            uiKitButton.heightAnchor.constraint(equalToConstant: 52),
            swiftUIButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }

    @objc private func showUIKitSample() {
        presentSample(UIKitBarChartViewController())
    }

    @objc private func showSwiftUISample() {
        presentSample(SwiftUIBarChartViewController())
    }

    private func presentSample(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

final class UIKitBarChartViewController: UIViewController {

    private let barChart = MSBBarChartView()
    private let barChart2 = MSBBarChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(close)
        )
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCharts()
    }

    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [barChart, barChart2])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false

        barChart.backgroundColor = .systemBackground
        barChart2.backgroundColor = .systemBackground
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart2.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            barChart.heightAnchor.constraint(equalToConstant: 216),
            barChart2.heightAnchor.constraint(equalToConstant: 216)
        ])
    }

    private func configureCharts() {
        barChart.setOptions([.yAxisTitle("Growth"), .yAxisNumberOfInterval(10)])
        barChart.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)]
        barChart.setDataEntries(values: [12,24,36,48,60,72,84,96])
        barChart.setXAxisUnitTitles(["Textiles", "IT", "Steel", "Apparel", "Retail", "Real Estate", "Staffing", "Banking"])
        barChart.start()

        barChart2.setOptions([.yAxisTitle("Sales"), .xAxisUnitLabel("M")])
        barChart2.assignmentOfColor =  [0.0..<0.14: #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), 0.14..<0.28: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), 0.28..<0.42: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), 0.42..<0.56: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), 0.56..<0.70: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), 0.70..<1.0: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        barChart2.setDataEntries(values: [16,32,64,128,256,512,1024,2048])
        barChart2.start()
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

final class SwiftUIBarChartViewController: UIHostingController<SwiftUIBarChartSampleView> {

    init() {
        super.init(rootView: SwiftUIBarChartSampleView())
        title = "SwiftUI"
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rootView = SwiftUIBarChartSampleView()
        title = "SwiftUI"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(close)
        )
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

struct SwiftUIBarChartSampleView: View {
    var body: some View {
        VStack(spacing: 32) {
            MSBBarChart(
                values: [12, 24, 36, 48, 60, 72, 84, 96],
                xAxisTitles: ["Textiles", "IT", "Steel", "Apparel", "Retail", "Real Estate", "Staffing", "Banking"]
            )
            .yAxisTitle("Growth")
            .yAxisNumberOfInterval(10)
            .frame(height: 216)

            MSBBarChart(
                values: [16, 32, 64, 128, 256, 512, 1024, 2048],
                xAxisTitles: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug"]
            )
            .yAxisTitle("Sales")
            .yAxisNumberOfInterval(8)
            .gradientBar(true)
            .frame(height: 216)
        }
        .padding(.horizontal, 8)
    }
}
