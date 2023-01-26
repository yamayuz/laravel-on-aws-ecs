<p>テストページ</p>

<form method="post" action="{{ route('register') }}">
    @csrf
    <input type="text" name="item">
    <button type="submit" name="submit">登録</button>
</form>
<div>
    @forelse($items as $item)
        <p>{{ $item['item'] }}</p>
    @empty
        <p>データがありません。</p>
    @endforelse
</div>
