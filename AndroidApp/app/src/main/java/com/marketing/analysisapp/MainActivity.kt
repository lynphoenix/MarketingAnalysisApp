package com.marketing.analysisapp

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val uploadButton = findViewById<Button>(R.id.uploadButton)
        val statusText = findViewById<TextView>(R.id.statusText)

        uploadButton.setOnClickListener {
            statusText.text = "营销数据分析 App\n\n点击了按钮！"
        }
    }
}
