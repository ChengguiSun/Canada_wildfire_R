## @knitr prepare_images
image_logo <- "./img/canada.png"
image_file1 <- "./img/wildfire_stable_diffusion.jpg"
image_file2 <- "./img/wildfire_stable_diffusion2.jpg"
image_file3 <- "./img/wildfire_stable_diffusion3.jpg"

image_logo <- base64enc::base64encode(image_logo)
image_string1 <- base64enc::base64encode(image_file1)
image_string2 <- base64enc::base64encode(image_file2)
image_string3 <- base64enc::base64encode(image_file3)