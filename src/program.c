#define MAX 200
#define MIN 21
void setup(void)
{
	pinMode(MIN, OUTPUT);
}

void loop(void)
{
	digitalWrite(MIN, HIGH);
	delay(MAX);
	digitalWrite(MIN, LOW);
	delay(MAX);
}
