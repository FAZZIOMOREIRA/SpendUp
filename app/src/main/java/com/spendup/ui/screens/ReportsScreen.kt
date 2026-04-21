package com.spendup.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.spendup.model.ReportItem
import com.spendup.ui.components.ReportBarRow

@Composable
fun ReportsScreen(reportItems: List<ReportItem>) {
    LazyColumn(
        contentPadding = PaddingValues(20.dp),
        verticalArrangement = Arrangement.spacedBy(18.dp)
    ) {
        item {
            Text(
                text = "Reports",
                style = MaterialTheme.typography.headlineSmall,
                fontWeight = FontWeight.Bold
            )
        }
        item {
            Card(shape = RoundedCornerShape(24.dp)) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(20.dp),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    reportItems.take(4).forEach { item ->
                        Column(
                            modifier = Modifier.weight(1f),
                            verticalArrangement = Arrangement.Bottom
                        ) {
                            Text(
                                text = item.category.take(3),
                                style = MaterialTheme.typography.labelSmall
                            )
                            Column(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height((60 + item.amount / 8).dp)
                                    .background(
                                        MaterialTheme.colorScheme.primary.copy(alpha = 0.22f),
                                        RoundedCornerShape(16.dp)
                                    )
                            ) {}
                        }
                    }
                }
            }
        }
        items(reportItems) { item ->
            ReportBarRow(item = item)
        }
    }
}
