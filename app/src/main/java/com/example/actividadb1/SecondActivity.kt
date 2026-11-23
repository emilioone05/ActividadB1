package com.example.actividadb1

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

/**
 * Segunda ventana (Activity 2).
 * Muestra un mensaje y un botón "Regresar" para volver a la pantalla principal.
 */
class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)

        val btnRegresar = findViewById<Button>(R.id.btn_regresar)

        // finish() cierra esta Activity y Android muestra de nuevo la anterior (MainActivity),
        // que sigue en la pila de actividades. No hace falta crear otro Intent.
        btnRegresar.setOnClickListener {
            finish()
        }
    }
}