module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message) # packages up the status info in a new class 'RecordResult'

  class Ledger
    def record(expense)
      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
    end
  end

end
