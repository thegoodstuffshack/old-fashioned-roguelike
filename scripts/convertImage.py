# convertImage.py
# convert image to byte array

import cv2


img = cv2.imread("test.png")
cv2.imshow("", img)


cv2.waitKey(0)
cv2.destroyAllWindows() 
print("cv2")