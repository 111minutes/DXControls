Customizable switch view.  
Interface is close to UISwitch.  
Don't forget to add QuartzCore framework to your project.  
Proper usage requires [[DXSwitch alloc] initWithFrame:...]. 
You would like to add pictures [setOnImage:offImage:] or text [setLabelsWithFont:onText:offText:] right after the switch initialization.  
Once set, labels or pictures on the switch cannot be changed.
Usage of images with UIEdgeInsets required for expected appearance.



Expample   
``` objective-c  
_switcher = [[DXSwitch alloc] initWithFrame:CGRectMake(20, 3, 200, 28)
                           onBackgroundImage:[bkgrOnImg resizableImageWithCapInsets:UIEdgeInsetsMake(bkgrOnImg.size.height/2, 28, bkgrOnImg.size.height/2, 0)]
                            offBackgroundImg:[bkgrOffImg resizableImageWithCapInsets:UIEdgeInsetsMake(bkgrOffImg.size.height/2, 0, bkgrOffImg.size.height/2, 28)]
                                  leverImage:[leverImage resizableImageWithCapInsets:UIEdgeInsetsMake(leverImage.size.height/2, leverImage.size.width/2, leverImage.size.height/2, leverImage.size.width/2)]];

[_switcher setLabelsWithFont:[UIFont fontWithName:@"Arial" size:7]  onText:@"okay" offText:@"not okay" onTextColor:[UIColor blackColor] offTextColor:[UIColor redColor]];
    
[_switcher addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
[_switcher addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
[_switcher addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];   
``` 
