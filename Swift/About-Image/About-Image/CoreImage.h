//CIDetector配置Key
//识别精确度的
CIDetectorAccuracy

//用于启用或禁用检测器的人脸跟踪的一个键。当您想跟踪视频帧中的面时，请使用此选项。
CIDetectorTracking

/*
 **->人脸检测器，它的值是一个浮点数NSNumber
 从0…1表示输入图像较短边缘的百分比。
 有效值范围为：0.01≤cidetectorminfeaturesize < = 0.5。
 设置此参数的较高值仅用于性能增益。默认值是0.15。* /
 **->矩形探测器，它的值是一个浮点数NSNumber
 从0…1表示输入图像较短边缘的百分比。
 有效值范围为：0.2≤cidetectorminfeaturesize <= 1的默认值是0.2。* /
 **->文本检测器，它的值是一个浮点数NSNumber
 从0…1表示输入图像高度的百分比。
 有效值范围为：0≤cidetectorminfeaturesize < = 1。默认值为10 /（输入图像的高度）
 */
CIDetectorMinFeatureSize

/*
 矩形探测器，它的值是一个整数的NSNumber
 从1…256表示返回的最大功能数。
 有效值范围：1 < = cidetectormaxfeaturecount < = 256。默认值是1。
 */
CIDetectorMaxFeatureCount

//用于检测视频输入中的人脸的透视数,选项字典中的键用于指定角度数，这个键的值是1，3，5，7，9，11。
CIDetectorNumberOfAngles
