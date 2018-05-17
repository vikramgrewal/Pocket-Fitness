import Foundation

extension Date {
   // Helper to create date from string retrieved from the database
   public static func getDateFromString(date : String) -> Date? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
      let workoutDate = dateFormatter.date(from: date)
      return workoutDate
   }
}
