package com.example.actividadb1

import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

/**
 * Segunda ventana (Activity 2): detalle del equipo y resumen de precio.
 * Tiene un botón para solicitar la reserva y otro para regresar al catálogo.
 */
class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)

        val btnReservar = findViewById<Button>(R.id.btn_reservar)
        val btnRegresar = findViewById<Button>(R.id.btn_regresar)

        // En ArtRider la reserva es una solicitud que el Partner revisa y acepta o rechaza
        btnReservar.setOnClickListener {
            Toast.makeText(this, R.string.toast_reserva, Toast.LENGTH_LONG).show()
        }

        // finish() cierra esta Activity y Android muestra de nuevo la anterior (MainActivity),
        // que sigue en la pila de actividades. No hace falta crear otro Intent.
        btnRegresar.setOnClickListener {
            finish()
        }
    }
}
