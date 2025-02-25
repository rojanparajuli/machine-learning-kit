package com.rojan.ml_kit_test

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "image_saver"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveImage" -> {
                    val imageData = call.argument<String>("imageData")
                    if (imageData != null) {
                        val filePath = saveImageToGallery(imageData)
                        if (filePath != null) {
                            refreshGallery(filePath)
                            result.success("success")
                        } else {
                            result.error("SAVE_FAILED", "Failed to save image", null)
                        }
                    } else {
                        result.error("INVALID_DATA", "Image data is null", null)
                    }
                }
                "refreshGallery" -> {
                    val imagePath = call.argument<String>("imagePath")
                    if (imagePath != null) {
                        refreshGallery(imagePath)
                        result.success("success")
                    } else {
                        result.error("INVALID_PATH", "Image path is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveImageToGallery(base64String: String): String? {
        return try {
            val decodedBytes = Base64.decode(base64String, Base64.DEFAULT)
            val bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)

            val contentValues = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, "scanned_image_${System.currentTimeMillis()}.png")
                put(MediaStore.Images.Media.MIME_TYPE, "image/png")
                put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
            }

            val contentResolver = applicationContext.contentResolver
            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

            uri?.let {
                contentResolver.openOutputStream(it)?.use { outputStream ->
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                    outputStream.flush()
                }
                return getRealPathFromURI(it)
            }
            null
        } catch (e: Exception) {
            Log.e("ImageSave", "Error saving image", e)
            null
        }
    }

    private fun refreshGallery(imagePath: String) {
        val file = File(imagePath)
        if (file.exists()) {
            val uri = Uri.fromFile(file)
            val scanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri)
            applicationContext.sendBroadcast(scanIntent)
        }
    }

    private fun getRealPathFromURI(uri: Uri): String {
        return uri.path ?: ""
    }
}
