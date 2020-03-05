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
    
    static var pickerType = 0
    
    let workLogContent: [WorkLogContent]
    
    init(workLogContent: [WorkLogContent]) {
        
        self.workLogContent = workLogContent
    }
    
    var chartModel: AAChartModel!
    
    var reportDate = Date()
    
    var workLogName = ""
    
    var dateString = ""
    
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let monthFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM"
           return formatter
    }()
    
    let yearFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy"
           return formatter
    }()
}

protocol ChartProvider {
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)? { get set }
    
    var filterDidChangerHandler: ((String) -> Void)? { get set }
    
    var pickerContent: [String] { get set }
    
    func didSelectedPickerContent(at index: Int)
        
    func chartViewModel() -> AAChartModel
    
    func chartView(didSelected data: String)
}

class DateReportManager: ReportManager, ChartProvider {
        
    var pickerContent: [String] = ["10/10", "10/11"]
    
    var filterDidChangerHandler: ((String) -> Void)?
    
    func didSelectedPickerContent(at index: Int) {
        
        let filter = pickerContent[index]
        
        // work log content
        
        // call targetWorkLogContentsDidChangeHandler
        
        // call filterDidChangerHandler
    
        filterDidChangerHandler?(filter)
    }
    
    func chartView(didSelected data: String) {
        
        var filterWorkLogContent: [WorkLogContent] = []
        
        for item in workLogContent {
            
            if item.date == data {
                
                filterWorkLogContent.append(item)
            }
        }
        
        targetWorkLogContentsDidChangeHandler?(filterWorkLogContent)
    }
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)?
    
    func chartViewModel() -> AAChartModel {
        
        var beforeSevenDates: [String] = []
        
        var sortArray = workLogContent.sorted(by: { $0.date < $1.date })
                
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for item in sortArray {
            
            if let logContentArray = resultDictionary[item.date] {
                
                resultDictionary[item.date] = logContentArray + [item]
                
            } else {
                
                resultDictionary[item.date] = [item]
            }
        }
        
        for i in 1...7 {
            
            switch ReportManager.pickerType {
                
            case 1:
                
               reportDate = Calendar.current.date(byAdding: .month, value: -i, to: Date()) ?? Date()
               
               dateString = monthFormatter.string(from: reportDate)
                
            case 2:
                
                reportDate = Calendar.current.date(byAdding: .year, value: -i, to: Date()) ?? Date()
                
                dateString = yearFormatter.string(from: reportDate)
                
            default:
                
                reportDate = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
                
                dateString = dayFormatter.string(from: reportDate)
                
            }
                        
            beforeSevenDates.append(dateString)
            
        }
        
        beforeSevenDates = beforeSevenDates.sorted(by: { $0 < $1 })
        
        var seriesElement: [Int] = []
        
        for item in beforeSevenDates {
            
            let workHour = resultDictionary[item]?.map{ $0.hour }.reduce(0, { (sum, num) in
                
                return sum + num
            })
            
            seriesElement.append(workHour ?? 0)
        }
        
        let element = AASeriesElement().name("Project").data(seriesElement)
        
        chartModel = AAChartModel()
        chartModel = chartModel.touchEventEnabled(true)
            .chartType(.line)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title(workLogName)//The chart title
            //        .subtitle("subtitle")//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
            .categories(Array(beforeSevenDates))
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([element])
            .markerSymbol(.diamond)
        return chartModel
    }
}

class PersonalReportManager: ReportManager, ChartProvider {
        
    var pickerContent: [String] = ["Sick", "Lady"]
    
    var filterDidChangerHandler: ((String) -> Void)?
    
    func didSelectedPickerContent(at index: Int) {
        
        
    }
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)?
    
    func chartView(didSelected data: String) {
        
        var filterWorkLogContent: [WorkLogContent] = []
        
        for item in workLogContent {
            
            if item.date == data {
                
                filterWorkLogContent.append(item)
            }
        }
        
        targetWorkLogContentsDidChangeHandler?(filterWorkLogContent)
    }
    
    func chartViewModel() -> AAChartModel {
        
        guard let uid = UserDefaults.standard.value(forKey: "userID") as? String else {
            return AAChartModel()
        }
        
        var beforeSevenDates: [String] = []
        
        var beforeSevenMonth: [String] = []
        
        var personalProject: [WorkLogContent] = []
        
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for i in 1...7 {
            
            guard let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) else {
                return AAChartModel()
            }
            
            guard let month = Calendar.current.date(byAdding: .month, value: -i, to: Date()) else {
                return AAChartModel()
            }
            
            let dateString = dayFormatter.string(from: date)
            
            let monthString = monthFormatter.string(from: month)
            
            beforeSevenDates.append(dateString)
            
            beforeSevenMonth.append(monthString)
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
        chartModel = chartModel.touchEventEnabled(true)
            .chartType(.area)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title("TITLE")//The chart title
            .subtitle("subtitle")//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
            .categories(Array(beforeSevenDates))
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([element])
            .markerSymbolStyle(.innerBlank)
        return chartModel
    }
}

class WorkItemReportManager: ReportManager, ChartProvider {
    
    var pickerContent: [String] = ["Yo", "Hi"]
    
    var filterDidChangerHandler: ((String) -> Void)?
    
    func didSelectedPickerContent(at index: Int) {
        
        
    }
    
    var workItem = "UI Design"
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)?
    
    func chartView(didSelected data: String) {
        
        var filterWorkLogContent: [WorkLogContent] = []
        
        for item in workLogContent {
            
            if item.date == data && item.workItem == workItem {
                
                filterWorkLogContent.append(item)
            }
        }
        
        targetWorkLogContentsDidChangeHandler?(filterWorkLogContent)
    }
    
    func chartViewModel() -> AAChartModel {
        
        var beforeSevenDates: [String] = []
        
        var workItemArray: [WorkLogContent] = []
        
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for i in 1...7 {
            
            guard let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) else {
                return AAChartModel()
            }
            
            let dateString = dayFormatter.string(from: date)
            
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
        chartModel = chartModel.touchEventEnabled(true)
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title("TITLE")//The chart title
            .subtitle("subtitle")//The chart subtitle
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
            .categories(Array(beforeSevenDates))
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series([element])
            .markerSymbolStyle(.borderBlank)
        return chartModel
    }
}
