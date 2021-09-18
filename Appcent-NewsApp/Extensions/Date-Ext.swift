//
//  Date-Ext.swift
//  Appcent-NewsApp
//
//  Created by Salim Uzun on 17.09.2021.
//

import Foundation

extension Date {
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm | MMM dd, yyyy"
        let date: Date? = dateFormatterGet.date(from: string)
        //print("Date",dateFormatterPrint.string(from: date ?? Date())) // Feb 01,2018
        return dateFormatterPrint.string(from: date ?? Date());
    }
}
