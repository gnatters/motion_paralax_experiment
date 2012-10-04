describe "ParallaxController", ->
  controller = null
  
  beforeEach ->
    @context.redirectTo "parallax"

  it "should do something", ->
    expect(@context.controller).toBeInstanceOf(Jax.Controller)
