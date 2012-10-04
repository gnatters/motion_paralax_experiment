model_data = 

class Jax.getGlobal().Sample extends Jax.Model
  after_initialize: ->
    @size = 0.01
    
    @mesh = new Jax.Mesh.Triangles
      init: (vertices, colors, texCoords, normals, indices) ->
        if model_data and model_data.vertices
          console.log model_data.vertices[0]
          vertices.push datum/490 for datum in model_data.vertices[0]["values"]
          normals.push  datum for datum in model_data.vertices[1]["values"]
          indices.push  datum for datum in model_data.connectivity[0]["indices"]
      update: ((updated_mesh) => 
        model_data = updated_mesh; @mesh.rebuild())

    @camera.lookAt [0,-1000,0]
    @camera.position = [-0.34,-0.25,-0.34]
    $.ajax
      type: 'GET'
      url: '/mybrain.json'
      success: (data) =>
        @mesh.update(data)
      
  update: (tc) ->
    if @rotation_speed
      @camera.rotate @rotation_speed*tc, [0,1,0]
