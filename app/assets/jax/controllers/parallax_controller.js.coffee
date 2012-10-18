movement = 
  forward: 0
  backward: 0
  left: 0
  right: 0

Jax.Controller.create "Parallax", ApplicationController,
  index: ->
    torus = new Jax.Model
      position: [0, 1, -7]
      mesh: new Jax.Mesh.Torus
        material: 'shiney'
    
    window.world = @world
    @world.addObject Sample.find "rotating"
    @world.addObject torus
    @world.addLight "sun"
    @world.addLight "candle"
    @cam_pos = {x:0,y:0,z:0}
    @offset =  {x:0,y:0,z:0}
    
    @face_tracking = false
    @video = document.createElement('video')
    @backCanvas = document.createElement('canvas')
    
    navigator.getUserMedia_ = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
    
    try
      navigator.getUserMedia_( {video: true, audio: false},
        ((stream)=>console.log("ok"); this.start(stream)),
        (()->console.log("denied")))
    catch e
      try
        navigator.getUserMedia_ 'video', (()->console.log("ok")), (()->console.log("denied"))
      catch e
        console.log e
      
    @video.loop = @video.muted = true;
    @video.load();
    
  start: (stream) ->
    @video.addEventListener 'canplay', ()=>
      @video.removeEventListener('canplay')
      @video.play()
      setTimeout( (() =>
        @video.play()
        @backCanvas.width = @video.videoWidth / 4
        @backCanvas.height = @video.videoHeight / 4
        @backContext = @backCanvas.getContext('2d')
        @face_tracking = true
      ), 500)
    domURL = window.URL || window.webkitURL
    @video.src = if domURL then domURL.createObjectURL(stream) else stream
  
  get_face_position: (cb) ->
    @backContext.drawImage(@video, 0, 0, @backCanvas.width, @backCanvas.height)
    	
    cb ccv.detect_objects(@ccv = @ccv || {
    	canvas: @backCanvas,
    	cascade: cascade,
    	interval: 4,
    	min_neighbors: 1
    })
  
  update: (tc) ->
    if @face_tracking
      this.get_face_position (comp) =>
        return false unless comp.length and comp[0].confidence > -1.5
        @offset.x += comp[0].x/250
        @offset.x /= 2
        @offset.y += comp[0].y/250
        @offset.y /= 2
        @activeCamera.position = [@cam_pos.x-@offset.x+0.25, @cam_pos.y-@offset.y+0.25, 0]
    else
      @activeCamera.move (movement.forward + movement.backward) * 0.01
      @activeCamera.strafe (movement.left + movement.right) * 0.01
        
    
  key_pressed: (event) ->
    switch event.keyCode
      when KeyEvent.DOM_VK_W then movement.forward  =  1
      when KeyEvent.DOM_VK_S then movement.backward = -1
      when KeyEvent.DOM_VK_A then movement.left     = -1
      when KeyEvent.DOM_VK_D then movement.right    =  1
  
  key_released: (event) ->
    switch event.keyCode
      when KeyEvent.DOM_VK_W then movement.forward  = 0
      when KeyEvent.DOM_VK_S then movement.backward = 0
      when KeyEvent.DOM_VK_A then movement.left     = 0
      when KeyEvent.DOM_VK_D then movement.right    = 0
  
  mouse_dragged: (event) ->
    @activeCamera.pitch 0.01 *  event.diffy
    @activeCamera.yaw   0.01 * -event.diffx
  
    