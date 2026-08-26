<?php

namespace App\Services\Broker;

interface BrokerInterface
{
    public function profile(): array;
    public function funds(): array;
    public function holdings(): array;
    public function positions(): array;
    public function quote(string $exchange, string $tradingsymbol, string $symbolToken): array;
    public function orders(): array;
    public function trades(): array;
    public function placeOrder(array $order): array;
    public function cancelOrder(string $orderId, string $variety = 'NORMAL'): array;
}
