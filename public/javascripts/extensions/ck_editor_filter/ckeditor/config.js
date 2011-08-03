/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
  config.toolbar = 'CustomToolbar';

  config.toolbar_CustomToolbar =
  [
  	{ name: 'styles', items : [ 'Format' ] },
  	{ name: 'basicstyles', items : [ 'Bold','Italic','Subscript','Superscript' ] },
  	{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock' ] },
  	'/',
  	{ name: 'tools', items : [ 'Maximize', 'ShowBlocks'] },
  	{ name: 'clipboard', items : [ 'PasteText','PasteFromWord'] },
  	{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
  	{ name: 'insert', items : [ 'Image','Table','HorizontalRule','SpecialChar','PageBreak' ] },
  	{ name: 'colors', items : [ 'TextColor','BGColor' ] }
  ];
  
};
