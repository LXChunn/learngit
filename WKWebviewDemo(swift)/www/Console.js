console = {
   log: function(string){
      window.webkit.messageHandlers.LXC.postMessage({className: 'Console',functionName:'log',data:string});
   }
}

