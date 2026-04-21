package com.spendup.model

data class Expense(
    val id: Int,
    val title: String,
    val category: String,
    val amount: Double,
    val date: String
)
