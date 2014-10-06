$("#conference_options").tristate()
updateTotal()
$("ul#conference_options input").change(function(){
  // If a conference day just got un-checked, uncheck all it's radiobutton day options
  if(!$(this).prop('checked') && $(this).prop('type') == "checkbox"){
    $(this).parent().find("input[type=radio]").filter(":checked").prop('checked', false)
  }
  if($(this).prop('checked') && $(this).prop('type') == "radio"){
    // A day option was just selected, make sure it's parent checkbox is checked
    $($(this).parents()[2]).children("input").prop('checked', true)
    $($(this).parents()[2]).children("input").trigger('change')
  }
  updateTotal()
})

function updateTotal(){
  var total = 0
  var total_cell = $("ul#conference_options li").last().children(".total")

  $("ul#conference_options li").first().each(function() {
    if($(this).children("input:checked").size() > 0){
      // full conference, don't bother digging
      price = parseInt( $(this).children(".levy").first().text().split("$")[1] );
      $(total_cell).html("$ " + price)
    }
    else{
      $("#conference_options ul li input:checked").each(function() {
        price = parseInt( $(this).parent().children(".levy").first().text().split("$")[1] );
          if($.isNumeric(price)){
            total += price
          }
      });
      $(total_cell).html("$ " + total)
    }
  })
}

function checkRadios(){
  var names = []
  var a_ok = true
  $("li input[type=radio]").each(function(){ names.push($(this).prop('name')) })
  $($.unique(names)).each(function(i){
    var options = $("input[name='"+names[i]+"']")
    var parent_cb = $(options.first().parents()[2]).children("input[type=checkbox]")
    var title = parent_cb.parent().children("label").html()
    if(parent_cb.prop("checked") && !options.filter(":checked").size()){
      alert("You must select at least one option for " + title + ".")
      a_ok = false
    }
  })
  return a_ok
}