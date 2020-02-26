//
//  ReportManager.swift
//  Project Butler
//
//  Created by Neal on 2020/2/21.
//  Copyright © 2020 neal812220. All rights reserved.
//

import Foundation
import UIKit
import AAInfographics

class ReportManager {
    
    var chartModel: AAChartModel!
    
    let date = Date()
    
    var workLogName = ""
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

protocol ChartProvider {
    
    func chartView(with workLogContent: [WorkLogContent]) -> AAChartModel
}

class DateReportManager: ReportManager, ChartProvider {
    
    func chartView(with workLogContent: [WorkLogContent]) -> AAChartModel {
            
            let sortArray = workLogContent.sorted(by: { $0.date < $1.date })
                    
            let allDate = Array(Set(sortArray.map{ $0.date })).sorted()
            
            var resultDictionary: [String: [WorkLogContent]] = [:]
            
            for item in sortArray {
                
                if let logContentArray = resultDictionary[item.date] {
                
                    resultDictionary[item.date] = logContentArray + [item]
                    
                } else {
                    
                    resultDictionary[item.date] = [item]
                }
            }
                    
            var count: Int
                
            if allDate.count < 8 {
                
                count = allDate.count
                
            } else {
                
                count = 7
            }
            
            let category = allDate.prefix(count)
            
            var seriesElement: [Int] = []
            
            for i in 0..<count {
                
                let workHours = resultDictionary[allDate[i]]!.map({ $0.hour }).reduce(0, { return $0 + $1 })
                
                seriesElement.append(workHours)
            }
            
            let element = AASeriesElement().name("Project").data(seriesElement)
            
            chartModel = AAChartModel()
            chartModel = chartModel.touchEventEnabled(true)
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title(workLogName)//The chart title
    //        .subtitle("subtitle")//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
            .categories(Array(category))
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([element])
            
            return chartModel
        }
}

class PersonalReportManager: ReportManager, ChartProvider {
    
    func chartView(with workLogContent: [WorkLogContent]) -> AAChartModel {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return AAChartModel()
        }
                
        var beforeSevenDates: [String] = []
                        
        var personalProject: [WorkLogContent] = []
                
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for i in 1...7 {
            
            guard let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) else {
                return AAChartModel()
            }
            
            let dateString = formatter.string(from: date)
            
            beforeSevenDates.append(dateString)
            
        }
        
        beforeSevenDates = beforeSevenDates.sorted(by: { $0 < $1 })
        
        for project in workLogContent {
            
            if project.userID == uid {
                
                personalProject.append(project)
            }
        }
        
        personalProject = personalProject.sorted(by: { $0.date < $1.date })
        
        for item in personalProject {
            
            if let logContentArray = resultDictionary[item.date] {
                
                resultDictionary[item.date] = logContentArray + [item]
                
            } else {
                
                resultDictionary[item.date] = [item]
            }
        }
        
        var seriesElement: [Int] = []
        
        for item in beforeSevenDates {
            
            let workHour = resultDictionary[item]?.map{ $0.hour }.reduce(0, { (sum, num) in
                return sum + num
            })
            
            seriesElement.append(workHour ?? 0)
        }
        
        let element = AASeriesElement().name("User").data(seriesElement)
        
        chartModel = AAChartModel()
        .chartType(.areaspline)//Can be any of the chart types listed under `AAChartType`.
        .animationType(.bounce)
        .title("TITLE")//The chart title
        .subtitle("subtitle")//The chart subtitle
        .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
        .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
        .categories(Array(beforeSevenDates))
        .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
        .series([element])
                
        return chartModel
    }
}

class WorkItemReportManager: ReportManager, ChartProvider {
    
    var workItem = "Look"
    
    func chartView(with workLogContent: [WorkLogContent]) -> AAChartModel {
        
        var beforeSevenDates: [String] = []
        
        var workItemArray: [WorkLogContent] = []
        
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for i in 1...7 {
            
            guard let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) else {
                return AAChartModel()
            }
            
            let dateString = formatter.string(from: date)
            
            beforeSevenDates.append(dateString)
            
        }
        
        beforeSevenDates = beforeSevenDates.sorted(by: { $0 < $1 })
        
        for item in workLogContent {
            
            if item.workItem == workItem {
                
                workItemArray.append(item)
            }
        }
        
        workItemArray = workItemArray.sorted(by: { $0.date < $1.date })
        
        for item in workItemArray {
            
            if let logContentArray = resultDictionary[item.date] {
                
               resultDictionary[item.date] = logContentArray + [item]
                
            } else {
                
                resultDictionary[item.date] = [item]
            }
        }
        
        var seriesElement: [Int] = []
        
        for item in beforeSevenDates {
            
            let workHour = resultDictionary[item]?.map{ $0.hour }.reduce(0, { (sum, num) in
                return sum + num
            })
            
            seriesElement.append(workHour ?? 0)
        }
        
        let element = AASeriesElement().name("Item").data(seriesElement)
        
        chartModel = AAChartModel()
        .chartType(.bar)//Can be any of the chart types listed under `AAChartType`.
        .animationType(.bounce)
        .title("TITLE")//The chart title
        .subtitle("subtitle")//The chart subtitle
        .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
        .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
        .categories(Array(beforeSevenDates))
        .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
        .series([element])
        
        return chartModel
    }
}
