<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}" class="h-100">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>tRFexplorer</title>
    <link href="{{ mix('/css/app.css') }}" rel="stylesheet">
</head>

<body class="h-100 w-100">
    <div class="d-flex flex-column h-100" id="app"></div>
    <script src="{{ mix('/js/app.js') }}"></script>
</body>

</html>