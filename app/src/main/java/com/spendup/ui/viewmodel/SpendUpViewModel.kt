package com.spendup.ui.viewmodel

import androidx.lifecycle.ViewModel
import com.spendup.model.BudgetSummary
import com.spendup.model.Expense
import com.spendup.model.Goal
import com.spendup.model.ReportItem
import com.spendup.model.Tip
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

data class SpendUpUiState(
    val email: String = "hello@spendup.app",
    val password: String = "",
    val isDarkMode: Boolean = false,
    val selectedExpenseId: Int? = null,
    val expenses: List<Expense> = fakeExpenses,
    val goals: List<Goal> = fakeGoals,
    val tips: List<Tip> = fakeTips,
    val reportItems: List<ReportItem> = fakeReports,
    val budgetSummary: BudgetSummary = BudgetSummary(
        income = 5200.0,
        expenses = fakeExpenses.sumOf { it.amount },
        remaining = 5200.0 - fakeExpenses.sumOf { it.amount }
    )
) {
    val totalBalance: Double = budgetSummary.remaining + 8340.0
    val recentExpenses: List<Expense> = expenses.take(4)
}

sealed interface SpendUpAction {
    data class UpdateEmail(val value: String) : SpendUpAction
    data class UpdatePassword(val value: String) : SpendUpAction
    data class SelectExpense(val expenseId: Int?) : SpendUpAction
    data class SaveExpense(
        val title: String,
        val amount: String,
        val category: String,
        val date: String
    ) : SpendUpAction
    data object ToggleTheme : SpendUpAction
}

class SpendUpViewModel : ViewModel() {

    private val _uiState = MutableStateFlow(SpendUpUiState())
    val uiState: StateFlow<SpendUpUiState> = _uiState.asStateFlow()

    fun onAction(action: SpendUpAction) {
        when (action) {
            is SpendUpAction.UpdateEmail -> _uiState.update { it.copy(email = action.value) }
            is SpendUpAction.UpdatePassword -> _uiState.update { it.copy(password = action.value) }
            is SpendUpAction.SelectExpense -> _uiState.update { it.copy(selectedExpenseId = action.expenseId) }
            SpendUpAction.ToggleTheme -> _uiState.update { it.copy(isDarkMode = !it.isDarkMode) }
            is SpendUpAction.SaveExpense -> saveExpense(action)
        }
    }

    private fun saveExpense(action: SpendUpAction.SaveExpense) {
        val current = _uiState.value
        val parsedAmount = action.amount.toDoubleOrNull() ?: 0.0
        val editedExpenseId = current.selectedExpenseId

        // Mock persistence: update the in-memory list and recalculate summary values.
        val updatedExpenses = if (editedExpenseId != null) {
            current.expenses.map { expense ->
                if (expense.id == editedExpenseId) {
                    expense.copy(
                        title = action.title,
                        amount = parsedAmount,
                        category = action.category,
                        date = action.date
                    )
                } else {
                    expense
                }
            }
        } else {
            listOf(
                Expense(
                    id = (current.expenses.maxOfOrNull { it.id } ?: 0) + 1,
                    title = action.title.ifBlank { "New Expense" },
                    category = action.category,
                    amount = parsedAmount,
                    date = action.date.ifBlank { "Apr 21" }
                )
            ) + current.expenses
        }

        val expenseTotal = updatedExpenses.sumOf { it.amount }
        val income = current.budgetSummary.income

        _uiState.update {
            it.copy(
                expenses = updatedExpenses,
                selectedExpenseId = null,
                budgetSummary = it.budgetSummary.copy(
                    expenses = expenseTotal,
                    remaining = income - expenseTotal
                )
            )
        }
    }

    companion object {
        private val fakeExpenses = listOf(
            Expense(1, "Groceries", "Food", 92.50, "Apr 20"),
            Expense(2, "Netflix", "Entertainment", 15.99, "Apr 19"),
            Expense(3, "Taxi Ride", "Transport", 23.40, "Apr 18"),
            Expense(4, "Coffee Beans", "Food", 18.20, "Apr 17"),
            Expense(5, "Electricity Bill", "Utilities", 120.00, "Apr 16"),
            Expense(6, "Gym Membership", "Health", 49.99, "Apr 15")
        )

        private val fakeGoals = listOf(
            Goal(1, "Emergency Fund", 5000.0, 3500.0),
            Goal(2, "Vacation in Tokyo", 2800.0, 1600.0),
            Goal(3, "New Laptop", 1800.0, 740.0)
        )

        private val fakeTips = listOf(
            Tip(1, "Automate savings", "Set a recurring transfer each payday to build momentum effortlessly."),
            Tip(2, "Review subscriptions", "Cancel services you have not used in the last 30 days."),
            Tip(3, "Use spending limits", "Create category caps to prevent overspending during busy weeks."),
            Tip(4, "Split essentials", "Separate fixed costs from lifestyle spending to see what is truly flexible.")
        )

        private val fakeReports = listOf(
            ReportItem("Food", 640.0, 0.78f),
            ReportItem("Transport", 280.0, 0.42f),
            ReportItem("Entertainment", 410.0, 0.54f),
            ReportItem("Utilities", 530.0, 0.71f),
            ReportItem("Health", 220.0, 0.36f)
        )
    }
}
