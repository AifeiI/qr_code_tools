package com.aifeii.qrcode.tools

import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import com.google.zxing.*
import com.google.zxing.common.HybridBinarizer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileInputStream
import java.util.*
import kotlin.collections.ArrayList
import android.graphics.Bitmap

class QrCodeToolsPlugin : FlutterPlugin, MethodCallHandler {

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "qr_code_tools")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "decoder") {
            val filePath = call.argument<String>("file")
            val file = File(filePath)
            var maxWidth:Int = 5616;
            var maxHeight:Int = 3744;
            var w:Int;
            var h:Int;
            var bitmap:Bitmap;
            
            if (!file.exists()) {
                result.error("File not found. filePath: $filePath", null, null)
                return
            }

            val fis = FileInputStream(file)
            bitmap = BitmapFactory.decodeStream(fis)
            w = bitmap.width
            h = bitmap.height

            if((w*h) > (maxWidth*maxHeight))
            {
                val scale : Float;
                if(w >= h)
                {
                    scale = maxWidth.toFloat()/w.toFloat()
                    w = maxWidth
                    h = (h*scale).toInt();
                } else {
                    scale = maxHeight.toFloat()/ h.toFloat();
                    h = maxHeight;
                    w = (w*scale).toInt();
                }
                bitmap = Bitmap.createScaledBitmap(bitmap, w, h, false);
            }
            
            val pixels = IntArray(w * h)
            bitmap.getPixels(pixels, 0, w, 0, 0, w, h)
            val source = RGBLuminanceSource(bitmap.width, bitmap.height, pixels)
            val binaryBitmap = BinaryBitmap(HybridBinarizer(source))

            val hints = Hashtable<DecodeHintType, Any>()
            val decodeFormats = ArrayList<BarcodeFormat>()
            decodeFormats.add(BarcodeFormat.QR_CODE)
            hints[DecodeHintType.POSSIBLE_FORMATS] = decodeFormats
            hints[DecodeHintType.CHARACTER_SET] = "utf-8"
            hints[DecodeHintType.TRY_HARDER] = true

            try {
                val decodeResult = MultiFormatReader().decode(binaryBitmap, hints)
                result.success(decodeResult.text)
            } catch (e: NotFoundException) {
                result.error("Not found data", null, null)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}