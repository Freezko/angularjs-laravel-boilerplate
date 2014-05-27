<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/


Blade::setContentTags('[[', ']]'); 		// for variables and all things Blade
Blade::setEscapedContentTags('[[[', ']]]'); 	// for escaped data



Route::get('views/{path}.html', function($path)
{

	if(strpos($path,'./') !== false){
		Redirect::to('/');
	}
	return View::make( 'ng/' . $path );
});

Route::any( '{all}', function( $uri ) {
	return View::make( 'layouts.master' );
})->where( 'all', '.*' );