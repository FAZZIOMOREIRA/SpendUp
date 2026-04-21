package com.spendup.model

data class BudgetSummary(
    val income: Double,
    val expenses: Double,
    val remaining: Double
) {
    val spentRatio: Float
        get() = (expenses / income).toFloat().coerceIn(0f, 1f)
}
