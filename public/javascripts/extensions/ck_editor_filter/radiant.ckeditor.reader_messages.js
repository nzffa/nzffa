function instantiateCkEditor(){
	CKEDITOR.config.startupOutlineBlocks = true
	CKEDITOR.config.colorButton_enableMore = false
	CKEDITOR.config.protectedSource.push( /<r:([\S]+)*>.*<\/r:\1>/g )
	CKEDITOR.config.protectedSource.push( /<r:[^>\/]*\/>/g )
	CKEDITOR.config.extraPlugins = 'MediaEmbed'
	CKEDITOR.config.forcePasteAsPlainText = true
	CKEDITOR.config.height = 500
	CKEDITOR.config.toolbar =
	[
		['Styles','Format'],
    ['Bold','Italic','Strike','-','Subscript','Superscript'],
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
    ['Paste', 'RemoveFormat'],
    ['Find','Replace'],
    ['Image', 'MediaEmbed', 'Table','HorizontalRule','SpecialChar'],
    ['Link','Unlink','Anchor'],
    ['Source', '-', 'Maximize']
	//// 	Alternative toolbar config
	//    ['Source','-','Templates'],
	//    ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker','-','RadiantPreview'],
	//    ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	//    ['Image','Paperclipped', 'MediaEmbed', 'Table','HorizontalRule','SpecialChar','PageBreak'],
	//		'/',
	//    ['Styles','Format'],
	//    ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	//    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
	//    ['JustifyLeft','JustifyCenter','JustifyRight'],
	//    ['Link','Unlink','Anchor'],
	//    ['Maximize','-','About']
	]
	CKEDITOR.on('instanceReady',
		function( evt ) {
			var editor = evt.editor
			var ck_holder = $("cke_" + editor.name)
			if(ck_holder){
				Droppables.add(ck_holder, {
					accept: 'asset',
					onDrop: function(element) {
						var link = element.select('a.bucket_link')[0]
						var classes = element.className.split(' ')
						var tag_type = classes[0]
						if(tag_type == 'image') {
			        var tag = '<img src="'+ link.href +'" />'
			      }
			      else {
			        var asset_id = element.id.split('_').last();
			        var tag = '<a href="'+ link.href +'">'+ link.title +'</a>'
			      }
						var element = CKEDITOR.dom.element.createFromHtml(tag)
						editor.insertElement(element)
				  }
				})
			}
    }
	)
	
	var usedFilter = $('message_filter_id')
	if(usedFilter.value == 'CKEditor'){
		putInEditor()
	}
	
  // var timer = setInterval(function() {
  //   // Make image asset draggable
  //   Asset.MakeDraggables
  //   // Make asset bucket thumbnails draggable
  //   $$('div.resized').each(function(element){
  //     if(!element.hasClassName("move"))
  //       new Draggable(element, { revert: true })
  //       element.addClassName('move')
  //   })
  // }, 5000);
	
}

function toggleEditor(){
	var filterId = $('message_filter_id')
	if(filterId.value == 'CKEditor'){
		putInEditor()
	} else {
		removeEditor()
	}
}

function removeEditor(){
	var instance = CKEDITOR.instances['message_body']
	instance.destroy()
}

function putInEditor(){
	var textarea = $('message_body')
	CKEDITOR.replace(textarea)
}

// InsertIntoCk = Behavior.create({
//   onclick: function(e) {
//     if (e) e.stop();
//     var part_name = TabControlBehavior.instances[0].controller.selected.caption;
//     var textbox = $('message_body');
//
//     var tag_parts = this.element.getAttribute('rel').split('_');
//     var href = this.element.getAttribute('href')
//     var tag_name = tag_parts[0];
//     var asset_size = tag_parts[1];
//     var asset_id = tag_parts[2];
//
//     if($('message_filter_id').value == 'CKEditor'){
//       editor = CKEDITOR.instances['message_body']
//       if(tag_name == 'image')
//         editor.insertHtml("<img src=\"" + href + "\" alt=\"\" />")
//       else
//         editor.insertHtml("<a href=\"" + href + "\">" + this.element.up(".back").down(".title").innerHTML + "</a>")
//     }
//     else{
//       var radius_tag = '<r:asset:' + tag_name;
//       if (asset_size != '') radius_tag = radius_tag + ' size="' + asset_size + '"';
//       radius_tag =  radius_tag +' id="' + asset_id + '" />';
//       Asset.InsertAtCursor(textbox, radius_tag);
//     }
//   }
// });
