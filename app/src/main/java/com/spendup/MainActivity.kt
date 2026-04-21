package com.spendup

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.getValue
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.spendup.navigation.AppNavHost
import com.spendup.ui.theme.SpendUpTheme
import com.spendup.ui.viewmodel.SpendUpViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            val viewModel: SpendUpViewModel = viewModel()
            val uiState by viewModel.uiState.collectAsStateWithLifecycle()

            SpendUpTheme(darkTheme = uiState.isDarkMode) {
                AppNavHost(
                    uiState = uiState,
                    onAction = viewModel::onAction
                )
            }
        }
    }
}
