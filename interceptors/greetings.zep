namespace HelloWorld;

class Greetings
{

    public static function hello()
    {
        return "Hello, World!";
    }

    public static function greet(string name)
    {
        return "Hello, " . name . "!";
    }

}