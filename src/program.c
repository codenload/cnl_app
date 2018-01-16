void setup(void)
{
	pinMode(21, OUTPUT);
}

void loop(void)
{
	digitalWrite(21, HIGH);
	delay(200);
	digitalWrite(21, LOW);
	delay(200);
}
