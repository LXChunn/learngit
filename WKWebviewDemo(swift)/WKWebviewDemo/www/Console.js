console = {
   log: function(string){
      window.webkit.messageHandlers.LXC.postMessage({AAA: 'Console',BBB:'log',data:string});
   }
}

