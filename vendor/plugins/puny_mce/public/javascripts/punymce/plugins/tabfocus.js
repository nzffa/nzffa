(function(a){function b(f,d){var e,c;e=d.parentNode;c=d.nextSibling;if(c){e.insertBefore(f,c)}else{e.appendChild(f)}return f}a.plugins.TabFocus=function(d){var c=a.Event,e=a.DOM;d.onInit.add(function(){var g,f,h;h=b(e.create("a",{href:"#"}),e.get(d.settings.id+"_c"));c.add(h,"focus",function(i){d.getWin().focus()});c.add(d.getDoc(),"keydown",function(i){if(i.keyCode==9){return c.cancel(i)}});c.add(d.getDoc(),"keydown",function(i){if(i.keyCode==9){window.focus();e.get(d.settings.tabfocus_id).focus()}})})}})(punymce);