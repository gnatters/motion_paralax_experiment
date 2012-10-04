describe "Sample", ->
  model = null
  
  describe "defaults", ->
    beforeEach ->
      model = new Sample()
      
  
  it "should create a default instance without failing", ->
    expect(-> new Sample()).not.toThrow()
  