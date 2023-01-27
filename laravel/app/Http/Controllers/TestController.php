<?php

namespace App\Http\Controllers;
use App\Models\Item;

use Illuminate\Http\Request;

class TestController extends Controller
{
    public function index()
    {
        $items = Item::select('item')->get();

        return view('index', compact('items'));
    }

    public function register(Request $request)
    {
        Item::create([
            'item' => $request['item']
        ]);

        return back();
    }
}
