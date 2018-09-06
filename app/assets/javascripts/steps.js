$("#pickup-form").validate({
  rules: {
      "delivery[pickup_attributes][first_name]": {
          required: true
      },
      "delivery[pickup_attributes][last_name]": {
          required: true
      },
      "delivery[pickup_attributes][address]": {
          required: true
      },
      "delivery[pickup_attributes][phone_number]": {
          required: true,
          number: true
      }
  },
  messages: {
      "delivery[pickup_attributes][first_name]": {
          required: "Please provide First name."
      },
      "delivery[pickup_attributes][last_name]": {
          required: "Please provide last name."
      },
      "delivery[pickup_attributes][address]": {
          required: "Please provide address."
      },
      "delivery[pickup_attributes][phone_number]": {
          required: "Please provide phone number."
      }
  }
});
$('.save_draft').click(function(e){
e.preventDefault()
var array =$('.dropOff-form').find("input");
array.toArray().forEach(function(ele){$(ele).rules('remove','required')});
$('.dropOff-form').find('input[name="commit"]').val("Save Draft")
$('.dropOff-form').submit()

});
$(function() {
  // limits the number of categories
  $('.delivery-dropOff').on('cocoon:after-insert', function() {
    check_to_hide_or_show_add_link();
  });

  $('.delivery-dropOff').on('cocoon:after-remove', function() {
    check_to_hide_or_show_add_link();
  });

  check_to_hide_or_show_add_link();

  function check_to_hide_or_show_add_link() {
    if ($('.delivery-dropOff .singledropoff').length == 5) {
      $('#add_dropoff').hide();
    } else {
      $('#add_dropoff').show();
    }
  }
})
function check_for_active_size(){
  var parent = $("input[type='radio']:checked").parent().parent();
  parent.addClass('active').siblings().removeClass('active');
}
check_for_active_size();
$(".item-size").on("click", function(){
  $(this).addClass("active").siblings().removeClass("active");
})
$("input[type='radio']").change(function(){
  var $this =  this;
  var parent_div =  this.parent().parent();
  parent_div.addClass('active').siblings().removeClass('active');
})

$('.delivery-dropOff').on('cocoon:after-insert', function(e, inserted_item){
    var num = $('.dropoff-field').length;
    var id = makeid();
    inserted_item.find('.dropoff-heading').attr('data-target','#collapseThree'+id)
    inserted_item.find('#collapseOne').attr('id','collapseThree'+id);
    var array =$(this).find("input");
    array.toArray().forEach(function(ele){$(ele).rules('add','required')});
    inserted_item.find('.dropoff-field').html('Dropoff '+num);
  }
 ) 
$('.item-detail').on('cocoon:after-insert', function(e, inserted_item){
    var num = $('.item-h').length;
    var id = makeid();
    inserted_item.find('.item-heading').attr('data-target','#collapseOne'+id)
    inserted_item.find('#collapseThree').attr('id','collapseOne'+id);
    var array =$(this).find("input");
    array.toArray().forEach(function(ele){$(ele).rules('add','required')});
    inserted_item.find('.item-h').html('Item '+num);
  }
 )
if($('.dropoff-h').length == 1){
  $(".dropoff-heading").click();
};
if($('.item-h').length == 1){
  $(".item-heading").click();
};

function makeid() {
  var text = "";
  var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for (var i = 0; i < 5; i++)
    text += possible.charAt(Math.floor(Math.random() * possible.length));

  return text;
}

$("#dropOff-form").validate({

  rules: {
        "delivery[dropoffs_attributes][0][first_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][0][last_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][0][phone_number]": {
            required: true
        },
        "delivery[dropoffs_attributes][0][address]": {
            required: true
        },
        "delivery[dropoffs_attributes][0][delivery_instructions]": {
            required: true
        },

        "delivery[dropoffs_attributes][1][first_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][last_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][phone_number]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][address]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][delivery_instructions]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][first_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][last_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][phone_number]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][address]": {
            required: true
        },
        "delivery[dropoffs_attributes][1][delivery_instructions]": {
            required: true
        },
        "delivery[dropoffs_attributes][2][first_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][2][last_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][2][phone_number]": {
            required: true
        },
        "delivery[dropoffs_attributes][2][address]": {
            required: true
        },
        "delivery[dropoffs_attributes][2][delivery_instructions]": {
            required: true
        },

        "delivery[dropoffs_attributes][4][first_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][4][last_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][4][phone_number]": {
            required: true
        },
        "delivery[dropoffs_attributes][4][address]": {
            required: true
        },
        "delivery[dropoffs_attributes][4][delivery_instructions]": {
            required: true
        },
        "delivery[dropoffs_attributes][5][first_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][5][last_name]": {
            required: true
        },
        "delivery[dropoffs_attributes][5][phone_number]": {
            required: true
        },
        "delivery[dropoffs_attributes][5][address]": {
            required: true
        },
        "delivery[dropoffs_attributes][5][delivery_instructions]": {
            required: true
        },
        "delivery[items_attributes][0][description]": {
          required: true
        },
        "delivery[items_attributes][1][description]": {
          required: true
        },
        "delivery[items_attributes][2][description]": {
          required: true
        },
        "delivery[items_attributes][3][description]": {
          required: true
        },
        "delivery[items_attributes][4][description]": {
          required: true
        },
        "delivery[items_attributes][5][description]": {
          required: true
        },
        "delivery[items_attributes][6][description]": {
          required: true
        }
    },
    submitHandler: function(form) { // <- pass 'form' argument in
      $(".save_submit").attr("disabled", true);
      form.submit(); // <- use 'form' argument here.
    }
});