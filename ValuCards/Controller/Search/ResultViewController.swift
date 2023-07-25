//
//  ResultViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 19/07/2023.
//

import UIKit
import Charts
//import DGCharts


class ResultViewController: UIViewController {
        
    @IBOutlet weak var lineChartView: LineChartView!
    
    var cardPriceData: [Double] = [25.0, 30.0, 28.0, 35.0, 40.0, 37.0, 42.0] // Exemple de données d'évolution de prix
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Configuration du graphique de ligne avec les données d'évolution des prix
            setupLineChartData()
        }
        
        func setupLineChartData() {
            var entries: [ChartDataEntry] = []
            
            // Ajouter les données d'évolution des prix au graphique
            for (index, price) in cardPriceData.enumerated() {
                let entry = ChartDataEntry(x: Double(index), y: price)
                entries.append(entry)
            }
            
            let dataSet = LineChartDataSet(entries: entries, label: "Évolution du prix")
            dataSet.setColor(.blue) // Couleur de la ligne du graphique
            dataSet.lineWidth = 2.0 // Épaisseur de la ligne du graphique
            dataSet.circleRadius = 4.0 // Taille du cercle aux points de données
            
            let data = LineChartData(dataSet: dataSet)
            lineChartView.data = data
            
            // Optionnel : personnalisation de l'axe X (labels des données)
            let xAxis = lineChartView.xAxis
            xAxis.labelPosition = .bottom // Position des labels en bas
            xAxis.labelCount = cardPriceData.count // Nombre de labels sur l'axe X
            xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"])
            
            // Optionnel : personnalisation de l'axe Y (labels des valeurs)
            let yAxis = lineChartView.leftAxis
            yAxis.labelCount = 6 // Nombre de labels sur l'axe Y
            yAxis.axisMinimum = cardPriceData.min() ?? 0 // Valeur minimale de l'axe Y
            yAxis.axisMaximum = cardPriceData.max() ?? 50 // Valeur maximale de l'axe Y
            
            // Optionnel : masquer l'axe droit
            lineChartView.rightAxis.enabled = false
            
            // Optionnel : masquer la description du graphique
            lineChartView.chartDescription.enabled = false
            
            // Optionnel : activer le zoom horizontal
            lineChartView.scaleXEnabled = true
        }
    }
