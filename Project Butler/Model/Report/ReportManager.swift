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
    
    var workLogContent: [WorkLogContent]
    
    var projectMembers: [AuthInfo]
    
    var projectDetail: ProjectDetail
    
    init(workLogContent: [WorkLogContent], projectMembers: [AuthInfo], projectDetail: ProjectDetail) {
        self.workLogContent = workLogContent
        
        self.projectMembers = projectMembers
        
        self.projectDetail = projectDetail
    }
    
    var chartModel: AAChartModel!
    
    var reportDate = Date()
    
    var workLogName = ""
    
    var dateString = ""
    
    var dayFormatterArray: [WorkLogContent] = []
    
    var monthFormatterArray: [WorkLogContent] = []
    
    var yearFormatterArray: [WorkLogContent] = []
    
    lazy var contentArray: [[WorkLogContent]] = [dayFormatterArray, monthFormatterArray, yearFormatterArray]
    
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
    
    var didChangechartModel: ((AAChartModel) -> Void)? { get set }
    
    var currentPickerContent: String { get }
    
    var pickerContent: [String] { get set }
    
    func didSelectedPickerContent(at index: Int)
    
    func chartViewModel() -> AAChartModel
    
    func chartView(didSelected data: String)
}

class DateReportManager: ReportManager, ChartProvider {
    
    var didChangechartModel: ((AAChartModel) -> Void)?
    
    var pickerContent: [String] = ["Day", "Month", "Year"]
    
    var filterDidChangerHandler: ((String) -> Void)?
    
    var selectedIndex: Int?
    
    var filterWorkLogContent: [WorkLogContent] = []
    
    var currentPickerContent: String {
        
        guard let index = selectedIndex else {
            
            return ""
        }
        
        return pickerContent[index]
    }
    
    func didSelectedPickerContent(at index: Int) {
        
        let filter = pickerContent[index]
        
        selectedIndex = index
        
        didChangechartModel?(chartViewModel())
        
        targetWorkLogContentsDidChangeHandler?(contentArray[selectedIndex ?? 0])
        
        filterDidChangerHandler?(filter)
    }
    
    func chartView(didSelected data: String) {
        
        filterWorkLogContent = []
        
        for item in contentArray[selectedIndex ?? 0] {
            
            if item.date == data {
                
                filterWorkLogContent.append(item)
            }
        }
        
        targetWorkLogContentsDidChangeHandler?(filterWorkLogContent)
    }
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)?
    
    func chartViewModel() -> AAChartModel {
        
        var beforeSevenDates: [String] = []
        
        let workContentArray = workLogContent
        
        var filterWorkContentarray = workLogContent.sorted(by: { $0.date < $1.date })
        
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for index in 0 ..< workContentArray.count {
            
            switch selectedIndex {
                
            case 1:
                
                if let monthDate = dayFormatter.date(from: filterWorkContentarray[index].date) {
                    
                    print(filterWorkContentarray[index].date)
                    let monthString = monthFormatter.string(from: monthDate)
                    
                    filterWorkContentarray[index].date = monthString
                    print(filterWorkContentarray[index].date)
                }
                
            case 2:
                
                if let monthDate = dayFormatter.date(from: filterWorkContentarray[index].date) {
                    
                    let monthString = yearFormatter.string(from: monthDate)
                    
                    filterWorkContentarray[index].date = monthString
                    
                    yearFormatterArray = filterWorkContentarray
                }
                
            default:
                
                dayFormatterArray = filterWorkContentarray
            }
        }
        
        contentArray[selectedIndex ?? 0] = filterWorkContentarray
        
        for item in filterWorkContentarray {
            
            if let logContentArray = resultDictionary[item.date] {
                
                resultDictionary[item.date] = logContentArray + [item]
                
            } else {
                
                resultDictionary[item.date] = [item]
            }
        }
        
        for i in 1...7 {
            
            switch selectedIndex {
                
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

class MemberReportManager: ReportManager, ChartProvider {
    
    var didChangechartModel: ((AAChartModel) -> Void)?
    
    var pickerContent: [String] = ["Day", "Month", "Year"]
    
    var filterDidChangerHandler: ((String) -> Void)?
    
    var selectedIndex: Int?
    
    var filterWorkLogContent: [WorkLogContent] = []
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)?
    
    var currentPickerContent: String {
        
        guard let index = selectedIndex else {
            
            return ""
        }
        
        return pickerContent[index]
    }
    
    func didSelectedPickerContent(at index: Int) {
        
        let filter = pickerContent[index]
        
        selectedIndex = index
        
        didChangechartModel?(chartViewModel())
        
        targetWorkLogContentsDidChangeHandler?(contentArray[selectedIndex ?? 0])
        
        filterDidChangerHandler?(filter)
    }
    
    func chartView(didSelected data: String) {
        
        filterWorkLogContent = []
        
        for item in contentArray[selectedIndex ?? 0] {
            
            if item.date == data {
                
                filterWorkLogContent.append(item)
            }
        }
        
        targetWorkLogContentsDidChangeHandler?(filterWorkLogContent)
    }
    
    func chartViewModel() -> AAChartModel {
        
        var beforeSevenDates: [String] = []
        
        let workContentArray = workLogContent
        
        var filterWorkContentarray = workLogContent.sorted(by: { $0.date < $1.date })
        
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for index in 0 ..< workContentArray.count {
            
            switch selectedIndex {
                
            case 1:
                
                if let monthDate = dayFormatter.date(from: filterWorkContentarray[index].date) {
                    
                    let monthString = monthFormatter.string(from: monthDate)
                    
                    filterWorkContentarray[index].date = monthString
                    
                }
                
            case 2:
                
                if let monthDate = dayFormatter.date(from: filterWorkContentarray[index].date) {
                    
                    let monthString = yearFormatter.string(from: monthDate)
                    
                    filterWorkContentarray[index].date = monthString
                    
                    yearFormatterArray = filterWorkContentarray
                }
                
            default:
                
                dayFormatterArray = filterWorkContentarray
            }
        }
        
        contentArray[selectedIndex ?? 0] = filterWorkContentarray
        
        for i in 1...7 {
            
            switch selectedIndex {
                
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
        
        for item in filterWorkContentarray {
            
            if let logContentArray = resultDictionary[item.userID] {
                
                resultDictionary[item.userID] = logContentArray + [item]
                
            } else {
                
                resultDictionary[item.userID] = [item]
            }
        }
        
        var usersName: [String] = []
        
        for member in projectMembers {
            
            usersName.append(member.userName)
        }
        
        var seriesElement: [Int] = []
        
        var seriesElements: [[Int]] = [[]]
        
        var elements: [AASeriesElement] = []
        
        for member in projectMembers {
            
            seriesElement = []
            
            print(member.userName)
            
            for date in beforeSevenDates {
                
                let workHour = resultDictionary[member.userID]?.map{
                    if $0.date == date { return $0.hour } else { return 0} }.reduce(0, { (sum, num ) in
                        
                        return sum + num
                    })
                
                seriesElement.append(workHour ?? 0)
            }
            
            seriesElements.append(seriesElement)
            
        }
        
        seriesElements.remove(at: 0)
        
        for index in 0 ..< seriesElements.count {
            
            elements.append(AASeriesElement().name(usersName[index]).data(seriesElements[index]))
        }
        
        chartModel = AAChartModel()
        chartModel = chartModel.touchEventEnabled(true)
            .chartType(.area)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.bounce)
            .title("")//The chart title
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .tooltipValueSuffix("Hour")//the value suffix of the chart tooltip
            .categories(Array(beforeSevenDates))
            .colorsTheme(["#fe117c","#ffc069","#06caf4","#7dffc0"])
            .series(elements)
            .markerSymbolStyle(.innerBlank)
        return chartModel
    }
}

class WorkItemReportManager: ReportManager, ChartProvider {
    
    var didChangechartModel: ((AAChartModel) -> Void)?
    
    var pickerContent: [String] = ["Day", "Month", "Year"]
    
    var filterDidChangerHandler: ((String) -> Void)?
    
    var selectedIndex: Int?
    
    var filterWorkLogContent: [WorkLogContent] = []
    
    var targetWorkLogContentsDidChangeHandler: (([WorkLogContent]) -> Void)?
    
    var currentPickerContent: String {
        
        guard let index = selectedIndex else {
            
            return ""
        }
        
        return pickerContent[index]
    }
    
    func didSelectedPickerContent(at index: Int) {
        
        let filter = pickerContent[index]
        
        selectedIndex = index
        
        didChangechartModel?(chartViewModel())
        
        targetWorkLogContentsDidChangeHandler?(contentArray[selectedIndex ?? 0])
        
        filterDidChangerHandler?(filter)
    }
    
    func chartView(didSelected data: String) {
        
        filterWorkLogContent = []
        
        for item in contentArray[selectedIndex ?? 0] {
            
            if item.date == data {
                
                filterWorkLogContent.append(item)
            }
        }
        
        targetWorkLogContentsDidChangeHandler?(filterWorkLogContent)
    }
    
    func chartViewModel() -> AAChartModel {
        
        var beforeSevenDates: [String] = []
        
        let workContentArray = workLogContent
        
        var filterWorkContentarray = workLogContent.sorted(by: { $0.date < $1.date })
        
        var resultDictionary: [String: [WorkLogContent]] = [:]
        
        for index in 0 ..< workContentArray.count {
            
            switch selectedIndex {
                
            case 1:
                
                if let monthDate = dayFormatter.date(from: filterWorkContentarray[index].date) {
                    
                    let monthString = monthFormatter.string(from: monthDate)
                    
                    filterWorkContentarray[index].date = monthString
                    
                }
                
            case 2:
                
                if let monthDate = dayFormatter.date(from: filterWorkContentarray[index].date) {
                    
                    let monthString = yearFormatter.string(from: monthDate)
                    
                    filterWorkContentarray[index].date = monthString
                    
                    yearFormatterArray = filterWorkContentarray
                }
                
            default:
                
                dayFormatterArray = filterWorkContentarray
            }
        }
        
        contentArray[selectedIndex ?? 0] = filterWorkContentarray
        
        for i in 1...7 {
            
            switch selectedIndex {
                
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
        
        for item in filterWorkContentarray {
            
            if let logContentArray = resultDictionary[item.workItem] {
                
                resultDictionary[item.workItem] = logContentArray + [item]
                
            } else {
                
                resultDictionary[item.workItem] = [item]
            }
        }
        
        var seriesElement: [Int] = []
        
        var seriesElements: [[Int]] = [[]]
        
        var elements: [AASeriesElement] = []
        
        for item in projectDetail.workItems {
            
            seriesElement = []
                        
            for date in beforeSevenDates {
                
                let workHour = resultDictionary[item]?.map{
                    
                    if $0.date == date { return $0.hour } else { return 0} }.reduce(0, { (sum, num ) in
                        
                        return sum + num
                    })
                
                seriesElement.append(workHour ?? 0)
            }
            
            seriesElements.append(seriesElement)
            
        }
        
        seriesElements.remove(at: 0)
        
        for index in 0 ..< seriesElements.count {
            
            elements.append(AASeriesElement().name(projectDetail.workItems[index]).data(seriesElements[index]))
        }
        
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
            .series(elements)
            .markerSymbolStyle(.borderBlank)
        return chartModel
    }
}
