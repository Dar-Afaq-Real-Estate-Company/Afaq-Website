@php
    $isAr = app()->getLocale() === 'ar';
    $img = $ad->images ?: asset('image/afaq.jpeg');
    $tx = $ad->transaction_type ?? '';
    $txLabel = str_contains($tx, 'يجار') ? ($isAr ? 'للإيجار' : 'For rent') : (str_contains($tx, 'بدل') ? ($isAr ? 'للبدل' : 'For exchange') : ($isAr ? 'للبيع' : 'For sale'));
    $commission = is_null($ad->has_commission ?? null) ? null : ((int) $ad->has_commission === 1 ? ($isAr ? 'بعمولة' : 'Commission') : ($isAr ? 'بدون عمولة' : 'No commission'));
    $isRent = str_contains($tx, 'يجار');
    $kwd = $isAr ? 'د.ك' : 'KWD';
@endphp
<a href="{{ route('details.show', $ad->id) }}" class="af-card" style="display:block;color:inherit">
    <div style="height:170px;background:#dfe7e9 url('{{ $img }}') center/cover;position:relative">
        <div style="position:absolute;top:12px;{{ $isAr ? 'right' : 'left' }}:12px;display:flex;gap:6px">
            <span class="af-chip" style="background:#fff;color:#0f4051">{{ $txLabel }}</span>
            @if (!empty($ad->is_featured))<span class="af-chip" style="background:#cba135;color:#0b3442">VIP</span>@endif
        </div>
        <div style="position:absolute;bottom:10px;{{ $isAr ? 'left' : 'right' }}:12px;background:rgba(11,52,66,.75);color:#fff;padding:3px 9px;border-radius:7px;font-size:11.5px">👁 {{ $ad->views_count ?? 0 }}</div>
    </div>
    <div style="padding:14px 16px 16px">
        <div style="font-weight:900;font-size:16px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{{ $ad->title ?: ($ad->type . ' ' . $txLabel) }}</div>
        <div style="font-size:13px;color:#7a8a90;margin-top:4px">📍 {{ $ad->region }}</div>
        <div style="display:flex;gap:12px;font-size:12.5px;color:#4b5d63;margin-top:10px;min-height:18px">
            @if ($ad->rooms)<span>🛏 {{ $ad->rooms }}</span>@endif
            @if ($ad->bathrooms)<span>🛁 {{ $ad->bathrooms }}</span>@endif
            @if ($ad->area)<span>📐 {{ $ad->area }} {{ $isAr ? 'م²' : 'm²' }}</span>@endif
        </div>
        <div style="display:flex;align-items:center;justify-content:space-between;margin-top:12px;padding-top:12px;border-top:1px solid #eef2f3">
            <div style="font-weight:900;font-size:18px;color:#0f4051">{{ number_format((float) $ad->price) }} {{ $kwd }}@if ($isRent)<span style="font-size:12px;color:#7a8a90;font-weight:700"> / {{ $isAr ? 'شهري' : 'month' }}</span>@endif</div>
            @if ($commission)<span class="af-chip af-chip-green">{{ $commission }}</span>@endif
        </div>
    </div>
</a>
