package com.spendup.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Assessment
import androidx.compose.material.icons.filled.Flag
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.ReceiptLong
import androidx.compose.material.icons.filled.Settings
import androidx.compose.ui.graphics.vector.ImageVector

sealed class Destination(val route: String) {
    data object Splash : Destination("splash")
    data object Login : Destination("login")
    data object Home : Destination("home")
    data object Expenses : Destination("expenses")
    data object AddExpense : Destination("add_expense?expenseId={expenseId}") {
        fun createRoute(expenseId: Int? = null): String {
            return if (expenseId == null) "add_expense" else "add_expense?expenseId=$expenseId"
        }
    }
    data object Budget : Destination("budget")
    data object Goals : Destination("goals")
    data object Reports : Destination("reports")
    data object Tips : Destination("tips")
    data object Settings : Destination("settings")
}

data class BottomNavItem(
    val route: String,
    val label: String,
    val icon: ImageVector
)

val bottomNavItems = listOf(
    BottomNavItem(Destination.Home.route, "Home", Icons.Default.Home),
    BottomNavItem(Destination.Expenses.route, "Expenses", Icons.Default.ReceiptLong),
    BottomNavItem(Destination.Goals.route, "Goals", Icons.Default.Flag),
    BottomNavItem(Destination.Reports.route, "Reports", Icons.Default.Assessment),
    BottomNavItem(Destination.Settings.route, "Settings", Icons.Default.Settings)
)
