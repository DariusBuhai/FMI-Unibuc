import numpy as np
import matplotlib.pyplot as plt

images = np.zeros((9, 400, 600))
for i in range(0, 9):
    img = np.load('images/car_%d.npy' % i)
    images[i] = img

sum_images = images.sum()
print('sum images', sum_images)

sum_per_image = np.sum(images, axis=(1, 2))
print('sum per image', sum_per_image)

print('indexul imaginii cu suma maxima', sum_per_image.argmax())

mean_image = np.mean(images, axis=0)
plt.imshow(mean_image, cmap='gray')
plt.show()

# Cu ajutorul functiei np.std(images.array), calculati  deviatia standard a imaginilor
# 400x600
std_image = np.std(images, axis=0)

# Normalizati imaginile. (se scade imaginea medie si se imparte rezultatul la deviatia standard)
normalized_images = (images - mean_image) / std_image # => normalized_images.shape =
print('normalized_images.shape', normalized_images.shape)
# (9 x 400 x 600) - (400 x 600)

# Decupați fiecare imagine, afișând numai liniile cuprinse între 200 și 300,
# respectiv coloanele cuprinse între 280 și 400.
cropped_images = images[:, 200:300, 280:400]
for cropped_image in cropped_images:
    plt.imshow(cropped_image, cmap='gray')
    plt.show()
