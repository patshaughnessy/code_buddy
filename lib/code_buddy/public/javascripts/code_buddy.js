  var Address = Backbone.Model.extend({
    selected: function() {
      return stack.selectedAddress() == this
    },
    
  });
  var Addresses = Backbone.Collection.extend({model:Address})

  var Stack = Backbone.Model.extend({
    initialize: function() {
      this.bind('change:selected', this.selectionChanged);
      this.set({
        addresses: new Addresses(this.get('stack_frames')) 
      })
    },
     
	  setSelection: function(newSelected) {
	    if (newSelected >= 0 && newSelected < this.addresses().size()) {
	      this.set({ selected: newSelected })
	    }
	  },

	  addresses: function() {
	    return this.get('addresses')
	  },
	  
    selectedAddress: function() {
      var selected = this.get('selected')
      return this.addresses().at(selected)
    },
     
    selectionChanged: function(x) {
      this.updateSelectedAddress(x)
      this.view.render()
    },

    updateSelectedAddress: function(x) {
      this.addresses().at(x.previousAttributes().selected).view.render()
      this.addresses().at(x.changedAttributes().selected).view.render()
    }
     
  
  });

  // ADDRESS VIEW - SELECTED ADDRESS IN BOLD
  var AddressView = Backbone.View.extend({
      tagName:  "li",
  
      template: _.template("<span class='container'><%= path %>:<%= line%><span class='overlay'></span></span>"),
  
      initialize: function() {
          _.bindAll(this, 'render', 'close');
          this.model.bind('change', this.render);
          this.model.view = this;
      },
  
      render: function() {
        var html = this.template(this.model.toJSON())
          
        $(this.el).html(html);
        if (this.model.selected()) {
            $(this.el).addClass('selected')
        } else {
            $(this.el).removeClass('selected')
        }
        return this;
      }
  })

  // STACK VIEW - LOGIC FOR ASSIGNING EACH ADDRESS VIEW TO EACH LI TAG
  var StackView = Backbone.View.extend({
  
    el: $("#stack"),
  
    events: {
          "keypress #stack"      : "changeSelectionOnArrow"
    },    

    initialize: function() {
        _.bindAll(this, 'render', 'close');
        this.model.bind('change', this.render);
        this.model.view = this;

        this.model.get('addresses').each(this.addOneAddress);
    },
    
    changeSelectionOnArrow: function(event) {
      var origSelection = this.model.get('selected')
	  var newSelection  = origSelection
      if (event.keyCode == 38) {
        newSelection = origSelection - 1
      } else if (event.keyCode == 40) {
        newSelection = origSelection + 1
      }
	  if (newSelection != origSelection) {
	  	this.model.setSelection(newSelection)

	    var offset = $(stack.selectedAddress().view.el).offset()
	    var windowHeight = $(window).height()
	    if (offset.top > windowHeight + $(window).scrollTop() - 10) {
	      // scroll down
	      $('html,body').animate({scrollTop: offset.top - 200}, 500);
	    } else if (offset.top < $(window).scrollTop() + 60) {
	      // scroll up
	      $('html,body').animate({scrollTop: offset.top - 500}, 500);
	    }
	  	return false
	  } else {
		return true
	  }
    },

    addOneAddress: function(address, index) {
      var view = new AddressView({model: address});
      this.$("#stack").append(view.render().el);
    },
    
    render: function() {
      $('#code').html(this.model.selectedAddress().get('code'))
    }
  
  })

