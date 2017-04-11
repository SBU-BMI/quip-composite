annotools.prototype.generateCompositeDataset = function() { 

  alert("hello from mergebutton3."); 
  
  var self = this;
 
//image variables
  var case_id=this.iid;
  console.log('case_id is: '+ case_id);

// user 
   var user = this.user;   
   console.log('user is: '+ user); 
  
  
   var composite_order  = {
          "data": {
              "user": user,
              "case_id": case_id
			  },
          "type": "composite_order"
      };
	
   jQuery.post('api/Data/compositeOrder.php', composite_order)
        .done(function (res) {
          var r = JSON.parse(res);
          var id = r.id;
          console.log("Composite Order submitted!, Job ID: "+id);		  
         
		  alert("Composite Order Processing...."); 
		  
          self.toolBar.titleButton.hide()
          self.toolBar.ajaxBusy.show();
            
	     //start polling
          pollOrder(id, function(err, data){        
            if(err){             
			  alert("Order failed! Couldn't process your order"); 
			  self.toolBar.ajaxBusy.hide();
              self.toolBar.titleButton.show();
            } else{
               setTimeout(function(){
				   self.toolBar.ajaxBusy.hide();
                   self.toolBar.titleButton.show(); 
                   self.getMultiAnnot();	
              },2000)
            }
          });
		  
        })
  
}//end of generateCompositeDataset


function pollOrder(id, cb){
  jQuery.get("api/Data/compositeOrder.php?id="+id, function(data){ 
    console.log(data.state);
    if(data.state.contains("fail")){
      cb({"error": "failed", data});
      return;
    }
    if(data.state.contains("comp")){ // is completed?
     cb(null, data);
     return;
    } else {
      //console.log(data.state);
      setTimeout(pollOrder(id, cb), 300);
    }
  });
}

