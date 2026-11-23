package com.example.actividadb1

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

/**
 * Pantalla principal (Activity 1).
 * Muestra un texto, una imagen y un botón que abre la segunda ventana.
 */
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Asocia esta Activity con su diseño XML (res/layout/activity_main.xml)
        setContentView(R.layout.activity_main)

        // findViewById busca en el XML la vista que tiene ese id
        val btnSiguiente = findViewById<Button>(R.id.btn_siguiente)

        // Al pulsar el botón se abre la segunda ventana mediante un Intent explícito
        btnSiguiente.setOnClickListener {
            // Intent explícito: indicamos exactamente qué Activity queremos abrir
            val intent = Intent(this, SecondActivity::class.java)
            startActivity(intent)
        }
    }
}