#import "../PS.h"
#import <objc/runtime.h>

%hook CAMZoomSlider

static void unhideSlider(id self)
{
	UISlider <zoomSliderDelegate> *slider = nil;
	object_getInstanceVariable(self, "__zoomSlider", (void **)&slider);
	if (slider == nil)
		object_getInstanceVariable(self, "_zoomSlider", (void **)&slider);
	if (slider == nil)
		return;
	if ([slider respondsToSelector:@selector(makeVisibleAnimated:)])
		[slider makeVisibleAnimated:YES];
	else
		[slider makeVisible];
}

%group iOS8Up

- (void)_startVisibilityTimer
{

}

%end

%group iOS7

- (void)startVisibilityTimer
{

}

%end

%end

%group iOS9Up

%hook CAMViewfinderViewController

- (void)_createZoomSliderIfNecessary
{
	%orig;
	unhideSlider(self.view);
}

- (void)viewDidLoad
{
	%orig;
	[self _createZoomSliderIfNecessary];
}

- (void)_updateForCurrentConfiguration
{
	%orig;
	unhideSlider(self);
}

- (void)updateControlVisibilityAnimated:(BOOL)animated
{
	%orig;
	unhideSlider(self);
}

%end

%end

%group iOS8

%hook CAMCameraView

- (void)viewDidAppear
{
	%orig;
	[self showZoomSlider];
}

- (void)cameraControllerPreviewDidStart:(id)arg1
{
	%orig;
	unhideSlider(self);
}

- (void)cameraController:(id)arg1 willChangeToMode:(int)mode device:(int)device
{
	%orig;
	unhideSlider(self);
}

- (void)_resetZoom
{
	%orig;
	unhideSlider(self);
}

%end

%end

%group iOS4567

%hook PLCameraView

- (void)viewDidAppear
{
	%orig;
	[self showZoomSlider];
}

- (void)cameraControllerPreviewDidStart:(id)arg1
{
	%orig;
	unhideSlider(self);
}

- (void)cameraControllerModeWillChange:(id)arg1
{
	%orig;
	unhideSlider(self);
}

- (void)_resetZoom
{
	%orig;
	unhideSlider(self);
}

- (void)_setOverlayControlsVisible:(BOOL)visible
{
	%orig;
	unhideSlider(self);
}

%end

%hook PLCameraZoomSlider

- (void)startVisibilityTimer
{

}

%end

%end

%ctor
{
	if ([NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.springboard"] && isiOS7Up)
		return;
	if (isiOS8Up) {
		if (isiOS9Up) {
			%init(iOS9Up);
		} else {
			%init(iOS8);
		}
		%init(iOS8Up);
	} else {
		if (isiOS7) {
			%init(iOS7);
		}
		%init(iOS4567);
	}
}
