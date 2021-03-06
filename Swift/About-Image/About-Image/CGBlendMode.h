//R表示结果，S表示包含alpha的原色，D表示包含alpha的目标色，Ra，Sa和Da分别是三个的alpha
//
case normal
//将源图像样本与背景图像样本相乘。这将导致至少两个贡献的样本颜色中的任一种颜色都是深色的。
case multiply
//将源图像样本的逆与背景图像样本的倒数相乘。这将导致至少两个贡献的样品颜色中的任何一种颜色都轻
case screen
//目标色和原色透明度的加成
case overlay
//通过选择较暗的样本（从源图像或背景）创建复合图像示例。其结果是，背景图像样本被替换的任何源图像样本是黑暗的。
//否则，背景图像样本保持不变。
case darken
//通过选择较轻的样本（从源图像或背景）创建复合图像样本。其结果是，背景图像样本被替换的任何源图像样本是明亮的。
//否则，背景图像样本保持不变。
case lighten
//暗背景图像样本反映源图像样本。指定白的源图像示例值不会产生更改。
case colorDodge

case colorBurn

case softLight

case hardLight

case difference

case exclusion

case hue

case saturation

case color

case luminosity


/* Available in Mac OS X 10.5 & later. R, S, and D are, respectively,
 premultiplied result, source, and destination colors with alpha; Ra,
 Sa, and Da are the alpha components of these colors.
 
 The Porter-Duff "source over" mode is called `kCGBlendModeNormal':
 R = S + D*(1 - Sa)
 
 Note that the Porter-Duff "XOR" mode is only titularly related to the
 classical bitmap XOR operation (which is unsupported by
 CoreGraphics). */

case clear /* R = 0 */

case copy /* R = S */

case sourceIn /* R = S*Da */

case sourceOut /* R = S*(1 - Da) */

case sourceAtop /* R = S*Da + D*(1 - Sa) */

case destinationOver /* R = S*(1 - Da) + D */

case destinationIn /* R = D*Sa */

case destinationOut /* R = D*(1 - Sa) */

case destinationAtop /* R = S*(1 - Da) + D*Sa */

case xor /* R = S*(1 - Da) + D*(1 - Sa) */

case plusDarker /* R = MAX(0, (1 - D) + (1 - S)) */

case plusLighter /* R = MIN(1, S + D) */
