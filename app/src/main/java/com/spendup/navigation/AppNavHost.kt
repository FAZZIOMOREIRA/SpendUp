package com.spendup.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavType
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.spendup.ui.components.SpendUpScaffold
import com.spendup.ui.screens.AddEditExpenseScreen
import com.spendup.ui.screens.BudgetScreen
import com.spendup.ui.screens.DashboardScreen
import com.spendup.ui.screens.ExpenseScreen
import com.spendup.ui.screens.GoalsScreen
import com.spendup.ui.screens.LoginScreen
import com.spendup.ui.screens.ReportsScreen
import com.spendup.ui.screens.SettingsScreen
import com.spendup.ui.screens.SplashScreen
import com.spendup.ui.screens.TipsScreen
import com.spendup.ui.viewmodel.SpendUpAction
import com.spendup.ui.viewmodel.SpendUpUiState

@Composable
fun AppNavHost(
    uiState: SpendUpUiState,
    onAction: (SpendUpAction) -> Unit
) {
    val navController = rememberNavController()
    val currentRoute = navController.currentBackStackEntryAsState().value?.destination?.route
    val showBottomBar = currentRoute in bottomNavItems.map { it.route }

    SpendUpScaffold(
        showBottomBar = showBottomBar,
        currentRoute = currentRoute,
        onNavigate = { route ->
            navController.navigate(route) {
                popUpTo(Destination.Home.route) {
                    saveState = true
                }
                launchSingleTop = true
                restoreState = true
            }
        }
    ) { innerPadding ->
        // A single NavHost keeps splash, auth, and the main app flow in one place.
        NavHost(
            navController = navController,
            startDestination = Destination.Splash.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            composable(Destination.Splash.route) {
                SplashScreen(
                    onFinished = {
                        navController.navigate(Destination.Login.route) {
                            popUpTo(Destination.Splash.route) { inclusive = true }
                        }
                    }
                )
            }
            composable(Destination.Login.route) {
                LoginScreen(
                    email = uiState.email,
                    password = uiState.password,
                    onEmailChange = { onAction(SpendUpAction.UpdateEmail(it)) },
                    onPasswordChange = { onAction(SpendUpAction.UpdatePassword(it)) },
                    onLoginClick = {
                        navController.navigate(Destination.Home.route) {
                            popUpTo(Destination.Login.route) { inclusive = true }
                        }
                    }
                )
            }
            composable(Destination.Home.route) {
                DashboardScreen(
                    uiState = uiState,
                    onBudgetClick = { navController.navigate(Destination.Budget.route) },
                    onTipsClick = { navController.navigate(Destination.Tips.route) }
                )
            }
            composable(Destination.Expenses.route) {
                ExpenseScreen(
                    expenses = uiState.expenses,
                    onAddExpense = {
                        onAction(SpendUpAction.SelectExpense(null))
                        navController.navigate(Destination.AddExpense.createRoute())
                    },
                    onEditExpense = { expenseId ->
                        onAction(SpendUpAction.SelectExpense(expenseId))
                        navController.navigate(Destination.AddExpense.createRoute(expenseId))
                    }
                )
            }
            composable(
                route = Destination.AddExpense.route,
                arguments = listOf(
                    navArgument("expenseId") {
                        type = NavType.IntType
                        defaultValue = -1
                    }
                )
            ) { backStackEntry ->
                val expenseId = backStackEntry.arguments?.getInt("expenseId")?.takeIf { it != -1 }

                AddEditExpenseScreen(
                    expense = uiState.expenses.firstOrNull { it.id == expenseId },
                    onBack = {
                        onAction(SpendUpAction.SelectExpense(null))
                        navController.popBackStack()
                    },
                    onSave = { title, amount, category, date ->
                        onAction(SpendUpAction.SelectExpense(expenseId))
                        onAction(SpendUpAction.SaveExpense(title, amount, category, date))
                        navController.popBackStack()
                    }
                )
            }
            composable(Destination.Budget.route) {
                BudgetScreen(
                    summary = uiState.budgetSummary,
                    onBack = { navController.popBackStack() }
                )
            }
            composable(Destination.Goals.route) {
                GoalsScreen(goals = uiState.goals)
            }
            composable(Destination.Reports.route) {
                ReportsScreen(reportItems = uiState.reportItems)
            }
            composable(Destination.Tips.route) {
                TipsScreen(
                    tips = uiState.tips,
                    onBack = { navController.popBackStack() }
                )
            }
            composable(Destination.Settings.route) {
                SettingsScreen(
                    email = uiState.email,
                    isDarkMode = uiState.isDarkMode,
                    onToggleTheme = { onAction(SpendUpAction.ToggleTheme) },
                    onLogout = {
                        navController.navigate(Destination.Login.route) {
                            popUpTo(navController.graph.findStartDestination().id) {
                                inclusive = true
                            }
                        }
                    }
                )
            }
        }
    }
}
