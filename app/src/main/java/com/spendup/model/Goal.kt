package com.spendup.model

data class Goal(
    val id: Int,
    val title: String,
    val targetAmount: Double,
    val savedAmount: Double
) {
    val progress: Float
        get() = (savedAmount / targetAmount).toFloat().coerceIn(0f, 1f)
}
