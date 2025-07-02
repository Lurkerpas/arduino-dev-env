void setup() {
    Serial.begin(9600);
}

void loop() {
    // Print test string
    Serial.print("I am alive!");
    // Die
    void (*reset)(void) = 0xfffe;
    reset();
}