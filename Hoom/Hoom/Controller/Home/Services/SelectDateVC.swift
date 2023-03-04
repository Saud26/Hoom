//
//  SelectDateVC.swift
//  Hoom
//
//  Created by Anish on 07/10/2020.
//

import UIKit
import JTAppleCalendar


protocol SelectDateDelegate {
    func dateAndtime(date:String,time:String)
}

class SelectDateVC: UIViewController {

    
    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topMonth: UILabel!
    @IBOutlet weak var datePIcker: UIDatePicker!
    
    var dateDelegate:SelectDateDelegate?
   
    let df = DateFormatter()
    let time = ["12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00"]
    
    var selectedDate = ""
    var selectedTime = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.scrollDirection = .horizontal
        self.calendar.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        if #available(iOS 14.0, *) {
            datePIcker.preferredDatePickerStyle = .inline
           
        }
        self.selectedDate = "\(datePIcker.date)"
    }
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        self.selectedDate = "\(sender.date)"
    }
    
    @IBAction func next(_ sender: Any) {
        
        calendar.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: Any) {
        
        calendar.scrollToSegment(.previous)
    }
    @IBAction func save(_ sender: UIButton) {
        if selectedDate == "" || selectedTime == "" {
            simpleAlert("Select your date and time")
        }else {
            let date = selectedDate.components(separatedBy: " ")
            dateDelegate?.dateAndtime(date:date[0], time: self.selectedTime)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

extension SelectDateVC : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return time.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TimeCell
        cell.timeLbl.text = time[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.selectedTime = time[indexPath.row]
    }
}


extension SelectDateVC : JTAppleCalendarViewDelegate ,JTAppleCalendarViewDataSource{
   
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2020 10 01")!
        let endDate = formatter.date(from: "2040 12 01")!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
           self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
           return cell
    }
    
  
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "MM-dd-yyyy"
        let mydate = formatter.string(from: cellState.date)
        print(formatter.string(from: cellState.date))
        
    }
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return true // Based on a criteria, return true or false
    }
    func configureCell(view: JTAppleCell?, cellState: CellState) {
       guard let cell = view as? DateCell  else { return }
       cell.dateLabel.text = cellState.text
       handleCellTextColor(cell: cell, cellState: cellState)
       handleCellSelected(cell: cell, cellState: cellState)
    }
  
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
           cell.isHidden = false
        } else {
           cell.isHidden = true
        }
    }
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
           
            cell.dateView.isHidden = false
        } else {
            cell.dateView.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print("scroll")
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func setupMonthLabel(date: Date) {
        df.dateFormat = "MMM"
        topMonth.text = df.string(from: date)
    }
  
}
