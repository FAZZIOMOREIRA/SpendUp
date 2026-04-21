package com.spendup.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.spendup.ui.components.BalanceCard
import com.spendup.ui.components.ExpenseListItem
import com.spendup.ui.components.GoalProgressCard
import com.spendup.ui.components.SectionHeader
import com.spendup.ui.viewmodel.SpendUpUiState

@Composable
fun DashboardScreen(
    uiState: SpendUpUiState,
    onBudgetClick: () -> Unit,
    onTipsClick: () -> Unit
) {
    LazyColumn(
        contentPadding = PaddingValues(20.dp),
        verticalArrangement = Arrangement.spacedBy(18.dp)
    ) {
        item {
            Text(
                text = "Hello, Alex",
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.Bold
            )
            Text(
                text = "Here is your financial snapshot for today.",
                color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f)
            )
        }
        item {
            BalanceCard(balance = uiState.totalBalance)
        }
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Button(
                    onClick = onBudgetClick,
                    modifier = Modifier.weight(1f)
                ) {
                    Text("View Budget")
                }
                Button(
                    onClick = onTipsClick,
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Money Tips")
                }
            }
        }
        item {
            SectionHeader(title = "Recent Expenses")
        }
        items(uiState.recentExpenses) { expense ->
            ExpenseListItem(expense = expense)
        }
        item {
            Spacer(modifier = Modifier.height(6.dp))
            SectionHeader(title = "Goals Progress")
        }
        items(uiState.goals.take(2)) { goal ->
            GoalProgressCard(goal = goal)
        }
    }
}
