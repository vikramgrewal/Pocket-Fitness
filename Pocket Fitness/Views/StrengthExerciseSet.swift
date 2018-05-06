import UIKit
import Eureka

final class StrengthExerciseSetCell: Cell<Bool>, CellType, UITextFieldDelegate {


//   @IBOutlet weak var userImageView: UIImageView!
//   @IBOutlet weak var nameLabel: UILabel!
//   @IBOutlet weak var emailLabel: UILabel!
//   @IBOutlet weak var dateLabel: UILabel!
   var weightInputContainer : UIView!
   var weightInput : UITextField!
   var weightInputLabel : UILabel!
   var repsInputContainer : UIView!
   var repsInput : UITextField!
   var repsInputLabel : UILabel!
   var textFieldDelegate : UITextFieldDelegate!

   required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   override func setup() {
      super.setup()


      height = { 45 }

      weightInputContainer = UIView()
      addSubview(weightInputContainer)
      weightInputContainer.translatesAutoresizingMaskIntoConstraints = false
      weightInputContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
      weightInputContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
      weightInputContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 23.0).isActive = true
      weightInputContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true

      weightInputLabel = UILabel()
      weightInputLabel.text = "Weight"
      weightInputContainer.addSubview(weightInputLabel)
      weightInputLabel.translatesAutoresizingMaskIntoConstraints = false
      weightInputLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
      weightInputLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      weightInputLabel.leadingAnchor.constraint(equalTo: weightInputContainer.leadingAnchor).isActive = true
      weightInputLabel.trailingAnchor.constraint(equalTo: weightInputContainer.centerXAnchor).isActive = true

      weightInput = UITextField()
      weightInput.placeholder = "0"
      weightInput.keyboardType = .decimalPad
      weightInputContainer.addSubview(weightInput)
      weightInput.translatesAutoresizingMaskIntoConstraints = false
      weightInput.topAnchor.constraint(equalTo: topAnchor).isActive = true
      weightInput.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      weightInput.leadingAnchor.constraint(equalTo: weightInputContainer.centerXAnchor).isActive = true
      weightInput.trailingAnchor.constraint(equalTo: weightInputContainer.trailingAnchor).isActive = true

      repsInputContainer = UIView()
      addSubview(repsInputContainer)
      repsInputContainer.translatesAutoresizingMaskIntoConstraints = false
      repsInputContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
      repsInputContainer.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
      repsInputContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 23.0).isActive = true
      repsInputContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true

      repsInputLabel = UILabel()
      repsInputLabel.text = "Reps"
      repsInputContainer.addSubview(repsInputLabel)
      repsInputLabel.translatesAutoresizingMaskIntoConstraints = false
      repsInputLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
      repsInputLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      repsInputLabel.leadingAnchor.constraint(equalTo: repsInputContainer.leadingAnchor).isActive = true
      repsInputLabel.trailingAnchor.constraint(equalTo: repsInputContainer.centerXAnchor).isActive = true

      repsInput = UITextField()
      repsInput.placeholder = "0"
      repsInput.keyboardType = .decimalPad
      repsInputContainer.addSubview(repsInput)
      repsInput.translatesAutoresizingMaskIntoConstraints = false
      repsInput.topAnchor.constraint(equalTo: topAnchor).isActive = true
      repsInput.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      repsInput.leadingAnchor.constraint(equalTo: repsInputContainer.centerXAnchor).isActive = true
      repsInput.trailingAnchor.constraint(equalTo: repsInputContainer.trailingAnchor).isActive = true
   }

   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      return false
   }

   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
      if action == #selector(UIResponderStandardEditActions.paste(_:)) {
         return false
      }
      return super.canPerformAction(action, withSender: sender)
   }

}

final class StrengthExerciseSetRow: Row<StrengthExerciseSetCell>, RowType {
   required init(tag: String?) {
      super.init(tag: tag)

      cellProvider = CellProvider<StrengthExerciseSetCell>()
   }
}
