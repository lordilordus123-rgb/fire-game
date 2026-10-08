shader_type spatial;

uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Standard: Weiß
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Standard: Schwarz
uniform float groesse = 10.0; // Bestimmt, wie viele Quadrate sichtbar sind

void fragment() {
    // 1. UV-Koordinaten mit der gewünschten Größe multiplizieren
    vec2 uv = UV * groesse;
    
    // 2. Mit floor() mathematische Kacheln erzeugen
    vec2 kachel = floor(uv);
    
    // 3. Prüfen, ob die Summe aus X und Y gerade oder ungerade ist
    // fract(* 0.5) erzeugt hier exakt wechselnde Werte von 0.0 und 0.5
    float muster = fract((kachel.x + kachel.y) * 0.5);
    
    // 4. Den Wert auf exakt 0.0 oder 1.0 bringen
    float checker = muster * 2.0; 
    
    // 5. Jetzt funktioniert mix() perfekt ohne Farbfehler
    ALBEDO = mix(color1.rgb, color2.rgb, checker);
}
