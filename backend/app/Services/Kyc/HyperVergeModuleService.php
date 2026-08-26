<?php

namespace App\Services\Kyc;

class HyperVergeModuleService
{
    public function enabled(): array
    {
        return array_keys(array_filter(config('hyperverge_modules.enabled', [])));
    }

    public function isEnabled(string $module): bool
    {
        return (bool) config("hyperverge_modules.enabled.$module", false);
    }
}
