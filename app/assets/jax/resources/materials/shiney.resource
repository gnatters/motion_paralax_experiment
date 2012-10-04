# Valid types include: Surface; Wire; Halo; Custom
type: Surface

# Colors are given in red, green, blue hex. They can also accept
# an optional alpha hex, which is used for transparency.
color:
  diffuse:  "#ffff00"
  specular: "#ffffff"

# Intensity multipliers so you can scale up or down the individual
# color components as it interacts with light.
intensity:
  ambient: 0.7
  diffuse: 0.7
  specular: 0.4

shininess: 50
layers:
  - type: PhongSpecular
  - type: LambertDiffuse
