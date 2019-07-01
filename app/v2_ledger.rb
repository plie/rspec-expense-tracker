module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message) # packages up the status info in a new class 'RecordResult'

  class Ledger
    def record(expense)
    end
  end

end
