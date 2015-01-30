$("#conference_options").tristate()
updateTotal()

if($("input[name*=single_or_couple]:checked").val() == 'couple'){
  $("input.partner").show()
}

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

$("input[name*=single_or_couple]").change(function(){
  if($("input[name*=single_or_couple]:checked").val() == 'couple'){
    $("input.partner").show()
  }
  else{
    $("input.partner").hide().prop('checked', false)
  }   
  updateTotal();
})

function updateTotal(){
  var total = 0
  var total_cell = $("ul#conference_options li").last().children(".total")

  $("ul#conference_options li").first().each(function() {
    var total = 0
    if($(this).children("input:checked").size() > 0){
      // use full conference price
      total = parseInt( $(this).children(".levy").first().text().split("$")[1] );

      if($("#conference_subscription_single_or_couple_couple").prop('checked')){
        total *= 2
      }

      // add extra day option prices if applicable
      $("#conference_options ul li input:checked").each(function() {
        price = parseInt( $(this).parent().attr('data-extra_levy') );
        if($.isNumeric(price)){
          total += price
        }
      });
    }
    else{
      // Add day registration levy if applicable
      to_add = parseInt($("ul#conference_options li").first().attr('data-day_registration_fee'))
      if($("#conference_subscription_single_or_couple_couple").prop('checked')){
        to_add *= 2
      }
      total += to_add
      
      $("#conference_options ul li input:checked").each(function() {
        price = parseInt( $(this).parent().children(".levy").first().text().split("$")[1] );
        if($(this).hasClass('partner') && $("#conference_subscription_single_or_couple_couple").prop('checked') ){
          if($.isNumeric(price)){
            total += price
          }
        }
        else{
          if($.isNumeric(price)){
            total += price
          }
        }
        
      });
    }
    $(total_cell).html("$ " + total)
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
    if(parent_cb.prop("checked") && !options.filter(":checked").size() && (names[i].indexOf('partner_option') == 0 || $("#conference_subscription_single_or_couple_couple").prop('checked') ) ){
      alert("You must select at least one option for " + title + ".")
      a_ok = false
    }
  })
  return a_ok
}