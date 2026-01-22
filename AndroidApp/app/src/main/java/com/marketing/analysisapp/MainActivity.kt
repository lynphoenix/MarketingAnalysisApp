package com.marketing.analysisapp

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : AppCompatActivity() {

    private lateinit var uploadButton: Button
    private lateinit var statusText: TextView

    private val FILE_PICKER_REQUEST = 1001
    private val PERMISSION_REQUEST = 1002

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        uploadButton = findViewById(R.id.uploadButton)
        statusText = findViewById(R.id.statusText)

        requestPermissions()

        uploadButton.setOnClickListener {
            openFilePicker()
        }
    }

    private fun requestPermissions() {
        val permissions = mutableListOf<String>()

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE)
            != PackageManager.PERMISSION_GRANTED) {
            permissions.add(Manifest.permission.READ_EXTERNAL_STORAGE)
        }

        if (permissions.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                this,
                permissions.toTypedArray(),
                PERMISSION_REQUEST
            )
        }
    }

    private fun openFilePicker() {
        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        startActivityForResult(intent, FILE_PICKER_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == FILE_PICKER_REQUEST && resultCode == RESULT_OK) {
            data?.data?.let { uri ->
                handleFileSelected(uri)
            }
        }
    }

    private fun handleFileSelected(uri: Uri) {
        val fileName = uri.lastPathSegment ?: "file.xlsx"
        statusText.text = "已选择文件: $fileName\n\n文件上传和AI分析功能需要后端支持。\n\n当前版本仅演示UI。"
        Toast.makeText(this, "文件已选择: $fileName", Toast.LENGTH_SHORT).show()
    }
}
