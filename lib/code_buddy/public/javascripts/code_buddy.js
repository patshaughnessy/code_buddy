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
        addresses: new Addresses(this.get('addresses')) 
      })
     },
     
     selectedAddress: function() {
       var selected = this.get('selected')
       return this.get('addresses').at(selected)
     },
     
     selectionChanged: function(x) {
       this.updateSelectedAddress(x)
       this.view.render()
     },
     
     updateSelectedAddress: function(x) {
       this.get('addresses').at(x.previousAttributes().selected).view.render()
       this.get('addresses').at(x.changedAttributes().selected).view.render()
     }
     
  
  });

  // ADDRESS VIEW - SELECTED ADDRESS IN BOLD
  var AddressView = Backbone.View.extend({
      tagName:  "li",
  
      template: _.template("<%= file %>:<%= line%>"),
  
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
      var selection = this.model.get('selected')
      if (event.keyCode == 38) {
        this.model.set({selected:  selection - 1})
        return false
      } else if (event.keyCode == 40) {
        this.model.set({selected:  selection + 1})
        return false
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

