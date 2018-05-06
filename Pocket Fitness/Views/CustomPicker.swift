import UIKit
import Eureka

open class _SplitRow<L: RowType, R: RowType>: Row<SplitRowCell<L,R>> where L: BaseRow, R: BaseRow{

   open override var section: Section?{
      get{ return super.section }
      set{
         rowLeft?.section = newValue
         rowRight?.section = newValue

         super.section = newValue
      }
   }

   open override func updateCell(){
      super.updateCell()

      self.rowLeft?.updateCell()
      self.rowLeft?.cell?.selectionStyle = .none

      self.rowRight?.updateCell()
      self.rowRight?.cell?.selectionStyle = .none
   }

   private(set) public var valueChanged = Set<SplitRowTag>()

   open override var value: SplitRowValue<L.Cell.Value, R.Cell.Value>?{
      get{ return super.value }
      set{
         valueChanged = []
         if super.value?.left != newValue?.left {
            valueChanged.insert(.left)
         }
         if super.value?.right != newValue?.right {
            valueChanged.insert(.right)
         }

         if self.rowLeft?.value != newValue?.left{
            self.rowLeft?.value = newValue?.left
            valueChanged.insert(.left)
         }

         if self.rowRight?.value != newValue?.right{
            self.rowRight?.value = newValue?.right
            valueChanged.insert(.right)
         }

         if false == valueChanged.isEmpty{
            super.value = newValue
         }
      }
   }

   public enum SplitRowTag: String{
      case left,right
   }

   public var rowLeft: L?{
      willSet{
         newValue?.tag = SplitRowTag.left.rawValue
         guard let row = newValue else{ return }

         var rowValue = self.value ?? SplitRowValue<L.Cell.Value,R.Cell.Value>()
         rowValue.left = row.value
         self.value = rowValue

         subscribe(onChange: row)
         subscribe(onCellHighlightChanged: row)
      }
   }
   public var rowLeftPercentage: CGFloat = 0.3

   public var rowRight: R?{
      willSet{
         newValue?.tag = SplitRowTag.right.rawValue
         guard let row = newValue else{ return }

         var rowValue = self.value ?? SplitRowValue<L.Cell.Value,R.Cell.Value>()
         rowValue.right = row.value
         self.value = rowValue

         subscribe(onChange: row)
         subscribe(onCellHighlightChanged: row)
      }
   }

   public var rowRightPercentage: CGFloat{
      return 1.0 - self.rowLeftPercentage
   }

   required public init(tag: String?) {
      super.init(tag: tag)
      cellProvider = CellProvider<SplitRowCell<L,R>>()
   }

   open func subscribe<T: RowType>(onChange row: T) where T: BaseRow{
      row.onChange{ [weak self] row in
         guard let strongSelf = self, let rowTagString = row.tag, let rowTag = SplitRowTag(rawValue: rowTagString) else{ return }
         strongSelf.cell?.update()  //TODO: This should only be done on cells which need an update. e.g. PushRow etc.

         var value = SplitRowValue<L.Cell.Value,R.Cell.Value>()
         if rowTag == .left {
            value.left = row.value as? L.Cell.Value
            value.right = strongSelf.value?.right
         } else if rowTag == .right {
            value.right = row.value as? R.Cell.Value
            value.left = strongSelf.value?.left
         }

         strongSelf.value = value
      }
   }

   open func subscribe<T: RowType>(onCellHighlightChanged row: T) where T: BaseRow{
      row.onCellHighlightChanged{ [weak self] cell, row in
         guard let strongSelf = self,
            let splitRowCell = strongSelf.cell,
            let formViewController = strongSelf.cell.formViewController()
            else { return }

         if cell.isHighlighted || row.isHighlighted {
            formViewController.beginEditing(of: splitRowCell)
         } else {
            formViewController.endEditing(of: splitRowCell)
         }
      }
   }
}

public final class SplitRow<L: RowType, R: RowType>: _SplitRow<L,R>, RowType where L: BaseRow, R: BaseRow{}

open class SplitRowCell<L: RowType, R: RowType>: Cell<SplitRowValue<L.Cell.Value,R.Cell.Value>>, CellType where L: BaseRow, R: BaseRow{
   var tableViewLeft: SplitRowCellTableView<L>!
   var tableViewRight: SplitRowCellTableView<R>!

   open override var isHighlighted: Bool {
      get { return super.isHighlighted || (tableViewLeft.row?.cell?.isHighlighted ?? false) || (tableViewRight.row?.cell?.isHighlighted ?? false) }
      set { super.isHighlighted = newValue }
   }

   public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      self.tableViewLeft = SplitRowCellTableView()
      tableViewLeft.separatorStyle = .none
      tableViewLeft.leftSeparatorStyle = .none
      tableViewLeft.translatesAutoresizingMaskIntoConstraints = false

      self.tableViewRight = SplitRowCellTableView()
      tableViewRight.separatorStyle = .none
      tableViewRight.leftSeparatorStyle = .singleLine
      tableViewRight.translatesAutoresizingMaskIntoConstraints = false

      contentView.addSubview(tableViewLeft)
      contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 0.0))

      contentView.addSubview(tableViewRight)
      contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: 0.0))
   }

   required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   open override func setup(){
      selectionStyle = .none

      //ignore Xcode Cast warning here, it works!
      guard let row = self.row as? _SplitRow<L,R> else{ return }

      //TODO: If we use UITableViewAutomaticDimension instead of 44.0 we encounter constraint errors :(
      let maxRowHeight = max(row.rowLeft?.cell?.height?() ?? 44.0, row.rowRight?.cell?.height?() ?? 44.0)
      if maxRowHeight != UITableViewAutomaticDimension{
         self.height = { maxRowHeight }
         row.rowLeft?.cell?.height = self.height
         row.rowRight?.cell?.height = self.height
      }

      tableViewLeft.row = row.rowLeft
      tableViewLeft.isScrollEnabled = false
      tableViewLeft.setup()

      tableViewRight.row = row.rowRight
      tableViewRight.isScrollEnabled = false
      tableViewRight.setup()

      setupConstraints()
   }


   open override func update(){
      tableViewLeft.update()
      tableViewRight.update()
   }

   private func setupConstraints(){
      guard let row = self.row as? _SplitRow<L,R> else{ return }

      if let height = self.height?(){
         self.contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
         self.contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
      }

      self.contentView.addConstraint(NSLayoutConstraint(item: tableViewLeft, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: row.rowLeftPercentage, constant: 0.0))
      self.contentView.addConstraint(NSLayoutConstraint(item: tableViewRight, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: row.rowRightPercentage, constant: 0.0))
   }

   private func rowCanBecomeFirstResponder(_ row: BaseRow?) -> Bool{
      guard let row = row else{ return false }
      return false == row.isDisabled && row.baseCell?.cellCanBecomeFirstResponder() ?? false
   }

   open override var isFirstResponder: Bool{
      guard let row = self.row as? _SplitRow<L,R> else{ return false }

      let rowLeftFirstResponder = row.rowLeft?.cell.findFirstResponder()
      let rowRightFirstResponder = row.rowRight?.cell?.findFirstResponder()

      return rowLeftFirstResponder != nil || rowRightFirstResponder != nil
   }

   open override func cellCanBecomeFirstResponder() -> Bool{
      guard let row = self.row as? _SplitRow<L,R> else{ return false }
      guard false == row.isDisabled else{ return false }

      let rowLeftFirstResponder = row.rowLeft?.cell.findFirstResponder()
      let rowRightFirstResponder = row.rowRight?.cell?.findFirstResponder()

      if rowLeftFirstResponder == nil && rowRightFirstResponder == nil{
         return rowCanBecomeFirstResponder(row.rowLeft) || rowCanBecomeFirstResponder(row.rowRight)

      } else if rowLeftFirstResponder == nil{
         return rowCanBecomeFirstResponder(row.rowLeft)

      } else if rowRightFirstResponder == nil{
         return rowCanBecomeFirstResponder(row.rowRight)
      }

      return false
   }

   open override func cellBecomeFirstResponder(withDirection: Direction) -> Bool {
      guard let row = self.row as? _SplitRow<L,R> else{ return false }

      let rowLeftFirstResponder = row.rowLeft?.cell.findFirstResponder()
      let rowLeftCanBecomeFirstResponder = rowCanBecomeFirstResponder(row.rowLeft)
      var isFirstResponder = false

      let rowRightFirstResponder = row.rowRight?.cell?.findFirstResponder()
      let rowRightCanBecomeFirstResponder = rowCanBecomeFirstResponder(row.rowRight)

      if withDirection == .down{
         if rowLeftFirstResponder == nil, rowLeftCanBecomeFirstResponder{
            isFirstResponder = row.rowLeft?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false

         } else if rowRightFirstResponder == nil, rowRightCanBecomeFirstResponder{
            isFirstResponder = row.rowRight?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false
         }

      } else if withDirection == .up{
         if rowRightFirstResponder == nil, rowRightCanBecomeFirstResponder{
            isFirstResponder = row.rowRight?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false

         } else if rowLeftFirstResponder == nil, rowLeftCanBecomeFirstResponder{
            isFirstResponder = row.rowLeft?.cell?.cellBecomeFirstResponder(withDirection: withDirection) ?? false
         }
      }

      if isFirstResponder {
         formViewController()?.beginEditing(of: self)
      }

      return isFirstResponder
   }

   open override func cellResignFirstResponder() -> Bool{
      guard let row = self.row as? _SplitRow<L,R> else{ return false }

      let rowLeftResignFirstResponder = row.rowLeft?.cell?.cellResignFirstResponder() ?? false
      let rowRightResignFirstResponder = row.rowRight?.cell?.cellResignFirstResponder() ?? false
      let resignedFirstResponder = rowLeftResignFirstResponder && rowRightResignFirstResponder

      if resignedFirstResponder {
         formViewController()?.endEditing(of: self)
      }

      return resignedFirstResponder
   }
}

public struct SplitRowValue<L: Equatable, R: Equatable>{
   public var left: L?
   public var right: R?

   public init(left: L?, right: R?){
      self.left = left
      self.right = right
   }

   public init(){}
}

extension SplitRowValue: Equatable{
   public static func == (lhs: SplitRowValue, rhs: SplitRowValue) -> Bool{
      return lhs.left == rhs.left && lhs.right == rhs.right
   }
}


class SplitRowCellTableView<T: TypedRowType>: UITableView, UITableViewDelegate, UITableViewDataSource{

   var row: T?

   var leftSeparatorStyle: UITableViewCellSeparatorStyle = .none{
      didSet{
         if oldValue != self.leftSeparatorStyle{
            self.reloadData()
         }
      }
   }

   override init(frame: CGRect, style: UITableViewStyle) {
      super.init(frame: frame, style: style)

      self.dataSource = self
      self.delegate = self
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   open func setup(){
      guard let row = self.row else{ return }
      row.baseCell.setup()
      row.baseCell.selectionStyle = .none
   }

   open func update(){
      guard let row = self.row else{ return }
      row.updateCell()
      row.baseCell.selectionStyle = .none
   }


   // MARK: UITableViewDelegate

   open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let row = self.row else{ return }

      // row.baseCell.cellBecomeFirstResponder() may be cause InlineRow collapsed then section count will be changed. Use orignal indexPath will out of  section's bounds.
      if !row.baseCell.cellCanBecomeFirstResponder() || !row.baseCell.cellBecomeFirstResponder() {
         tableView.endEditing(true)
      }
      row.didSelect()
   }

   open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard let row = self.row else{ return tableView.rowHeight }
      return row.baseCell.height?() ?? tableView.rowHeight
   }

   open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
      guard let row = self.row else{ return tableView.rowHeight }
      return row.baseCell.height?() ?? tableView.estimatedRowHeight
   }

   open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return false
   }


   // MARK: UITableViewDataSource

   open func numberOfSections(in tableView: UITableView) -> Int {
      return self.row == nil ? 0 : 1
   }

   open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.row == nil ? 0 : 1
   }

   open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let row = self.row else{ fatalError() }

      if let cell = row.baseCell, leftSeparatorStyle == .singleLine, false == cell.subviews.contains(where: { $0.backgroundColor == .groupTableViewBackground }){
         let separatorView = UIView()
         separatorView.backgroundColor = .groupTableViewBackground
         separatorView.translatesAutoresizingMaskIntoConstraints = false

         cell.addSubview(separatorView)
         cell.bringSubview(toFront: separatorView)

         cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separatorView(1)]", options: [], metrics: nil, views: ["separatorView":separatorView]))
         cell.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 11.0))
         cell.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: -11.0))
      }

      return row.baseCell
   }
}
