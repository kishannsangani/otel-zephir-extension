<?php

declare(strict_types=1);
require __DIR__ . '/vendor/autoload.php';

use GuzzleHttp\Client;
use GuzzleHttp\Psr7\HttpFactory;
use HelloWorld\Greetings;
use OpenTelemetry\SDK\Trace\SpanExporter\ConsoleSpanExporter;
use OpenTelemetry\SDK\Trace\SpanProcessor\SimpleSpanProcessor;
use OpenTelemetry\Contrib\OtlpHttp\Exporter as OtlpHttpExporter;
use OpenTelemetry\SDK\Trace\TracerProvider;

echo 'Starting OtlpHttpExporter' . PHP_EOL;

$tracerProvider =  new TracerProvider(
    new SimpleSpanProcessor(
        new OtlpHttpExporter(new Client(), new HttpFactory(), new HttpFactory())
    )
);

$tracer = $tracerProvider->getTracer('io.opentelemetry.contrib.php');

$rootSpan = $tracer->spanBuilder('root')->startSpan();
$rootSpan->activate();
for ($x = 0; $x <= 10; $x++) {
    echo $x . PHP_EOL;
    try {
        $span1 = $tracer->spanBuilder('foo')->startSpan();
        $span1->activate();
        
        echo Greetings::hello() . PHP_EOL;
        echo Greetings::greet("Kishan") . PHP_EOL;
        
        // try {
        //     $span2 = $tracer->spanBuilder('bar')->startSpan();
        //     for ($x = 0; $x <= 10000; $x++) {
        //         echo "The number is: $x";
        //       }
        // } finally {
        //     $span2->end();
        // }
    } finally {
        $span1->end();
    }
}
$rootSpan->end();