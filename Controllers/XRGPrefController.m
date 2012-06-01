/* 
 * XRG (X Resource Graph):  A system resource grapher for Mac OS X.
 * Copyright (C) 2002-2012 Gaucho Software, LLC.
 * You can view the complete license in the LICENSE file in the root
 * of the source tree.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */

//
//  PrefController.m
//

#import "XRGPrefController.h"
#import "XRGAppDelegate.h"
#import "XRGGraphWindow.h"
#import "definitions.h"

@implementation XRGPrefController
- (void)awakeFromNib {
    // Create a toolbar
    toolbar = [[[NSToolbar alloc] initWithIdentifier:@"preferenceToolbar"] retain];
    
    // instantiate the dictionary that will hold the toolbar item list
    toolbarItems = [[NSMutableDictionary dictionary] retain];
   
    // add the General toolbar item
    NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"General"] autorelease];
    [item setLabel:@"General"];
    [item setPaletteLabel:@"General"];
    [item setToolTip:@"General Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-General.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(General:)];
    [toolbarItems setObject:item forKey:@"General"];

    // add the Appearance toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Colors"] autorelease];
    [item setLabel:@"Appearance"];
    [item setPaletteLabel:@"Appearance"];
    [item setToolTip:@"Graph Color, Opacity, and Font Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Appearance.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(Colors:)];
    [toolbarItems setObject:item forKey:@"Appearance"];
    
    // add the CPU toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"CPU"] autorelease];
    [item setLabel:@"CPU"];
    [item setPaletteLabel:@"CPU"];
    [item setToolTip:@"CPU Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-CPU.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(CPU:)];
    [toolbarItems setObject:item forKey:@"CPU"];
    
    // add the Memory toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"RAM"] autorelease];
    [item setLabel:@"Memory"];
    [item setPaletteLabel:@"Memory"];
    [item setToolTip:@"Memory Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Memory.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(RAM:)];
    [toolbarItems setObject:item forKey:@"RAM"];

    // add the Temperature toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Temperature"] autorelease];
    [item setLabel:@"Temperature"];
    [item setPaletteLabel:@"Temperature"];
    [item setToolTip:@"Temperature Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Temperature.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(Temperature:)];
    [toolbarItems setObject:item forKey:@"Temperature"];
    
    // add the Network toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Network"] autorelease];
    [item setLabel:@"Network"];
    [item setPaletteLabel:@"Network"];
    [item setToolTip:@"Network Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Network.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(Network:)];
    [toolbarItems setObject:item forKey:@"Network"];

    // add the Disk toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Disk"] autorelease];
    [item setLabel:@"Disk"];
    [item setPaletteLabel:@"Disk"];
    [item setToolTip:@"Disk Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Disk.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(Disk:)];
    [toolbarItems setObject:item forKey:@"Disk"];
     
    // add the Weather toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Weather"] autorelease];
    [item setLabel:@"Weather"];
    [item setPaletteLabel:@"Weather"];
    [item setToolTip:@"Weather Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Weather.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(Weather:)];
    [toolbarItems setObject:item forKey:@"Weather"];

    // add the Stocks toolbar item
    item = [[[NSToolbarItem alloc] initWithItemIdentifier:@"Stocks"] autorelease];
    [item setLabel:@"Stocks"];
    [item setPaletteLabel:@"Stocks"];
    [item setToolTip:@"Stock Graph Options"];
    [item setImage:[NSImage imageNamed:@"Preferences-Stocks.tiff"]];
    [item setTarget:self];
    [item setAction:@selector(Stocks:)];
    [toolbarItems setObject:item forKey:@"Stocks"];
    // we want to handle the actions for the toolbar
    [toolbar setDelegate:self];
	[toolbar setSelectedItemIdentifier:@"General"];
	[window setTitle:@"General Preferences"];

    // set the GeneralPrefView as the default
    NSRect standardSize = [GeneralPrefView frame];
    [window setContentView:GeneralPrefView];
    [window setContentSize:standardSize.size];
    currentView = GeneralPrefView;
    
    // turn off the customization palette.  
    [toolbar setAllowsUserCustomization:NO];

    // tell the toolbar that it should not save any configuration changes to user defaults.  
    [toolbar setAutosavesConfiguration: NO]; 
    
    [toolbar setDisplayMode: NSToolbarDisplayModeIconAndLabel];  
    [window setToolbar:toolbar];                             // install the toolbar.


    // Now do other initializations of the preference controls.
    [[NSColorPanel sharedColorPanel] setContinuous:YES];
    
    xrgGraphWindow = [(XRGAppDelegate *)[NSApp delegate] xrgGraphWindow];
    
    // Initialize the panel outlets
    [self setUpGeneralPanel];
    [self setUpColorPanel];
    [self setUpCPUPanel];
    [self setUpMemoryPanel];
    [self setUpTemperaturePanel];
    [self setUpNetworkPanel];
    [self setUpDiskPanel];
    [self setUpWeatherPanel];
    [self setUpStockPanel];
}

- (IBAction)save:(id)sender {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        
    [defs setFloat: [backgroundTransparency floatValue] forKey:XRG_backgroundTransparency];
    [defs setFloat: [graphBGTransparency floatValue]    forKey:XRG_graphBGTransparency];
    [defs setFloat: [graphFG1Transparency floatValue]   forKey:XRG_graphFG1Transparency];
    [defs setFloat: [graphFG2Transparency floatValue]   forKey:XRG_graphFG2Transparency];
    [defs setFloat: [graphFG3Transparency floatValue]   forKey:XRG_graphFG3Transparency];
    [defs setFloat: [borderTransparency floatValue]     forKey:XRG_borderTransparency];
    [defs setFloat: [textTransparency floatValue]       forKey:XRG_textTransparency];
    
    [defs setObject:
        [NSArchiver archivedDataWithRootObject: [backgroundColorWell color]]
        forKey: XRG_backgroundColor
    ];
    [defs setObject:
        [NSArchiver archivedDataWithRootObject:[graphBGColorWell color]]
        forKey: XRG_graphBGColor
    ];
    [defs setObject:
        [NSArchiver archivedDataWithRootObject:[graphFG1ColorWell color]]
        forKey: XRG_graphFG1Color
    ];
    [defs setObject:
        [NSArchiver archivedDataWithRootObject: [graphFG2ColorWell color]]
        forKey: XRG_graphFG2Color
    ];
    [defs setObject:
        [NSArchiver archivedDataWithRootObject: [graphFG3ColorWell color]]
        forKey: XRG_graphFG3Color
    ];
    [defs setObject:
        [NSArchiver archivedDataWithRootObject: [borderColorWell color]]
        forKey: XRG_borderColor
    ];
    [defs setObject:
        [NSArchiver archivedDataWithRootObject: [textColorWell color]]
        forKey: XRG_textColor
    ];
    
    if ([graphOrientation indexOfSelectedItem] == 0)
        [defs setObject: @"YES" forKey:XRG_graphOrientationVertical];
    else 
        [defs setObject: @"NO"  forKey:XRG_graphOrientationVertical];
    
    [xrgGraphWindow setICAO:ICAOCode];
    if ([ICAOCode stringValue]) 
        [defs setObject: [ICAOCode stringValue] forKey:XRG_ICAO];
    else 
        [defs setObject: @"" forKey:XRG_ICAO];
    
        
    [defs setInteger: [secondaryWeatherGraph indexOfSelectedItem] forKey:XRG_secondaryWeatherGraph];
    [defs setInteger: [borderWidthSlider intValue] forKey:XRG_borderWidth];
    [defs setInteger: [temperatureUnits indexOfSelectedItem] forKey:XRG_temperatureUnits];
    [defs setInteger: [distanceUnits indexOfSelectedItem] forKey:XRG_distanceUnits];
    [defs setInteger: [pressureUnits indexOfSelectedItem] forKey:XRG_pressureUnits];
    [defs setFloat:   [graphRefreshValue floatValue] forKey:XRG_graphRefresh]; 
    [defs setObject: ([generalAutoExpandGraph state] == NSOnState ? @"YES" : @"NO")  forKey:XRG_autoExpandGraph];
    [defs setObject: ([generalForegroundWhenExpanding state] == NSOnState ? @"YES" : @"NO") forKey:XRG_foregroundWhenExpanding];
    [defs setObject: ([generalShowSummary state] == NSOnState ? @"YES" : @"NO")      forKey:XRG_showSummary];
    [defs setInteger: [generalMinimizeUpDown indexOfSelectedItem]                    forKey:XRG_minimizeUpDown];
    [defs setObject: ([appearanceAntialiasText state] == NSOnState ? @"YES" : @"NO") forKey:XRG_antialiasText];
    
    [defs setObject: ([showCPUGraph state] == NSOnState ? @"YES" : @"NO")            forKey:XRG_showCPUGraph];    
    [defs setObject: ([showMemoryGraph state] == NSOnState ? @"YES" : @"NO")         forKey:XRG_showMemoryGraph];    
    [defs setObject: ([showBatteryGraph state] == NSOnState ? @"YES" : @"NO")        forKey:XRG_showBatteryGraph];
    [defs setObject: ([showTemperatureGraph state] == NSOnState ? @"YES" : @"NO")    forKey:XRG_showTemperatureGraph];
    [defs setObject: ([showNetGraph state] == NSOnState ? @"YES" : @"NO")            forKey:XRG_showNetworkGraph];    
    [defs setObject: ([showDiskGraph state] == NSOnState ? @"YES" : @"NO")           forKey:XRG_showDiskGraph];    
    [defs setObject: ([showWeatherGraph state] == NSOnState ? @"YES" : @"NO")        forKey:XRG_showWeatherGraph];    
    [defs setObject: ([showStockGraph state] == NSOnState ? @"YES" : @"NO")          forKey:XRG_showStockGraph];   
     
    // CPU graph checkboxes
    [defs setObject: ([fastCPUUsageCheckbox state] == NSOnState ? @"YES" : @"NO")    forKey:XRG_fastCPUUsage];
    [defs setObject: ([enableAntiAliasing state] == NSOnState ? @"YES" : @"NO")      forKey:XRG_antiAliasing];
    [defs setObject: ([separateCPUColor state] == NSOnState ? @"YES" : @"NO")        forKey:XRG_separateCPUColor];
    [defs setObject: ([showLoadAverage state] == NSOnState ? @"YES" : @"NO")         forKey:XRG_showLoadAverage];
    [defs setObject: ([showCPUTemperature state] == NSOnState ? @"YES" : @"NO")      forKey:XRG_showCPUTemperature];
    [defs setInteger: [cpuTemperatureUnits indexOfSelectedItem] forKey:XRG_cpuTemperatureUnits];
    [defs setObject: ([cpuShowAverageUsage state] == NSOnState ? @"YES" : @"NO")     forKey:XRG_cpuShowAverageUsage];
    [defs setObject: ([cpuShowUptime state] == NSOnState ? @"YES" : @"NO")           forKey:XRG_cpuShowUptime];

    // Memory graph checkboxes
    [defs setObject: ([memoryShowPagingGraph state] == NSOnState ? @"YES" : @"NO")   forKey:XRG_showMemoryPagingGraph];    
    [defs setObject: ([memoryShowWired state] == NSOnState ? @"YES" : @"NO")         forKey:XRG_memoryShowWired];    
    [defs setObject: ([memoryShowActive state] == NSOnState ? @"YES" : @"NO")        forKey:XRG_memoryShowActive];    
    [defs setObject: ([memoryShowInactive state] == NSOnState ? @"YES" : @"NO")      forKey:XRG_memoryShowInactive];    
    [defs setObject: ([memoryShowFree state] == NSOnState ? @"YES" : @"NO")          forKey:XRG_memoryShowFree];    
    [defs setObject: ([memoryShowCache state] == NSOnState ? @"YES" : @"NO")         forKey:XRG_memoryShowCache];    
    [defs setObject: ([memoryShowPage state] == NSOnState ? @"YES" : @"NO")          forKey:XRG_memoryShowPage];
    
    // Temperature graph options
    [defs setInteger: [tempUnits indexOfSelectedItem]                                forKey:XRG_tempUnits];
    [defs setInteger: [tempFG1Location indexOfSelectedItem]                          forKey:XRG_tempFG1Location];
    [defs setInteger: [tempFG2Location indexOfSelectedItem]                          forKey:XRG_tempFG2Location];
    [defs setInteger: [tempFG3Location indexOfSelectedItem]                          forKey:XRG_tempFG3Location];
     
    [defs setObject: ([stockShowChange state] == NSOnState ? @"YES" : @"NO")         forKey:XRG_stockShowChange];    
    [defs setObject: ([showDJIA state] == NSOnState ? @"YES" : @"NO")                forKey:XRG_showDJIA];
    [defs setObject: ([stickyWindow state] == NSOnState ? @"YES" : @"NO")            forKey:XRG_stickyWindow];
    [defs setObject: ([checkForUpdates state] == NSOnState ? @"YES" : @"NO")         forKey:XRG_checkForUpdates];
    [defs setObject: ([dropShadow state] == NSOnState ? @"YES" : @"NO")              forKey:XRG_dropShadow];
    [defs setObject: ([showTotalBandwidthSinceBoot state] == NSOnState ? @"YES" : @"NO") forKey:XRG_showTotalBandwidthSinceBoot];
    [defs setObject: ([showTotalBandwidthSinceLoad state] == NSOnState ? @"YES" : @"NO") forKey:XRG_showTotalBandwidthSinceLoad];

    [defs setInteger:[netGraphMode selectedRow] forKey:XRG_netGraphMode];
    [defs setInteger:[diskGraphMode selectedRow] forKey:XRG_diskGraphMode];
    
    // save the minNetGraphScale
    int sInt = [[netMinGraphScaleValue stringValue] intValue];
    if (sInt == INT_MAX || sInt == INT_MIN) {
        sInt = 0;
    }
    if (sInt == 0) {
        if (![[netMinGraphScaleValue stringValue] isEqualToString:@"0"]) {
            sInt = 0;
        }
    }

    if ([netMinGraphScaleUnits indexOfSelectedItem] == 0)
        [defs setInteger:sInt forKey:XRG_netMinGraphScale];
    else if ([netMinGraphScaleUnits indexOfSelectedItem] == 1) 
        [defs setInteger:sInt * 1024 forKey:XRG_netMinGraphScale];
    else
        [defs setInteger:sInt * 1048576 forKey:XRG_netMinGraphScale];
    // done saving the minNetGraphScale
    
    int selectedRow = [networkInterface indexOfSelectedItem];
    if (selectedRow == 0) {
        [defs setObject:@"All" forKey:XRG_networkInterface];
    }
    else {
        NSArray *interfaces = [[xrgGraphWindow netView] networkInterfaces];
        if (selectedRow - 1 < [interfaces count])
            [defs setObject:[interfaces objectAtIndex:(selectedRow - 1)] forKey:XRG_networkInterface];
        else
            [defs setObject:@"All" forKey:XRG_networkInterface];
    }

    [xrgGraphWindow setStockSymbols:stockSymbols];
    if ([stockSymbols stringValue])
        [defs setObject:[stockSymbols stringValue] forKey:XRG_stockSymbols];
    else 
        [defs setObject:@"" forKey:XRG_stockSymbols];

    [xrgGraphWindow setWindowTitle:windowTitle];
    if ([windowTitle stringValue])
        [defs setObject:[windowTitle stringValue] forKey:XRG_windowTitle];
    else
        [defs setObject:@"" forKey:XRG_windowTitle];
        
    [defs setInteger:[stockGraphTimeFrame indexOfSelectedItem] forKey:XRG_stockGraphTimeFrame];
        
    [defs setInteger:[windowLevel indexOfSelectedItem] - 1 forKey:XRG_windowLevel];
    
    [defs setObject:[NSArchiver archivedDataWithRootObject:[[xrgGraphWindow appSettings] graphFont]] forKey:XRG_graphFont];
    
    [defs synchronize];
    [window orderOut:nil];
}

- (IBAction)revert:(id)sender {
}

- (void)setUpGeneralPanel {
    // Setup the window title
    [windowTitle setTarget:xrgGraphWindow];
    [windowTitle setAction:@selector(setWindowTitle:)];
    if ([[xrgGraphWindow appSettings] windowTitle] != nil)
        [windowTitle setStringValue:[[xrgGraphWindow appSettings] windowTitle]];
    else
        [windowTitle setStringValue:@""];
    
    // Setup the border width
    [borderWidthSlider setTarget:xrgGraphWindow];
    [borderWidthSlider setAction:@selector(setBorderWidthAction:)];
    [borderWidthSlider setIntValue:[xrgGraphWindow borderWidth]];
    
    // Setup the graph orientation
    [graphOrientation setTarget:xrgGraphWindow];
    [graphOrientation setAction:@selector(setGraphOrientation:)];
    if ([[xrgGraphWindow moduleManager] graphOrientationVertical]) 
        [graphOrientation selectItemAtIndex:0];
    else
        [graphOrientation selectItemAtIndex:1];
    
    // Setup anti-aliasing
    [enableAntiAliasing setTarget:xrgGraphWindow];
    [enableAntiAliasing setAction:@selector(setAntiAliasing:)];
    if ([[xrgGraphWindow appSettings] antiAliasing]) 
        [enableAntiAliasing setState:NSOnState];
    else
        [enableAntiAliasing setState:NSOffState];

    // Setup show CPU graph
    [showCPUGraph setTarget:xrgGraphWindow];
    [showCPUGraph setAction:@selector(setShowCPUGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"CPU"] isDisplayed])
        [showCPUGraph setState:NSOnState];
    else
        [showCPUGraph setState:NSOffState];
        
    // Setup show memory graph
    [showMemoryGraph       setTarget:xrgGraphWindow];
    [showMemoryGraph       setAction:@selector(setShowMemoryGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Memory"] isDisplayed]) 
        [showMemoryGraph setState:NSOnState];
    else
        [showMemoryGraph setState:NSOffState];

    // Setup show battery graph
    [showBatteryGraph setTarget:xrgGraphWindow];
    [showBatteryGraph setAction:@selector(setShowBatteryGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Battery"] isDisplayed])
        [showBatteryGraph setState:NSOnState];
    else
        [showBatteryGraph setState:NSOffState];

    // Setup show temperature graph
    [showTemperatureGraph setTarget:xrgGraphWindow];
    [showTemperatureGraph setAction:@selector(setShowTemperatureGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Temperature"] isDisplayed])
        [showTemperatureGraph setState:NSOnState];
    else
        [showTemperatureGraph setState:NSOffState];

    // Setup show network graph
    [showNetGraph setTarget:xrgGraphWindow];
    [showNetGraph setAction:@selector(setShowNetGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Network"] isDisplayed])
        [showNetGraph setState:NSOnState];
    else
        [showNetGraph setState:NSOffState];
    
    // Setup show disk graph
    [showDiskGraph setTarget:xrgGraphWindow];
    [showDiskGraph setAction:@selector(setShowDiskGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Disk"] isDisplayed])
        [showDiskGraph setState:NSOnState];
    else
        [showDiskGraph setState:NSOffState];

    // Setup show weather graph
    [showWeatherGraph setTarget:xrgGraphWindow];
    [showWeatherGraph setAction:@selector(setShowWeatherGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Weather"] isDisplayed])
        [showWeatherGraph setState:NSOnState];
    else
        [showWeatherGraph setState:NSOffState];

    // Setup show stock graph
    [showStockGraph setTarget:xrgGraphWindow];
    [showStockGraph setAction:@selector(setShowStockGraph:)];
    if ([[[xrgGraphWindow moduleManager] getModuleByName:@"Stock"] isDisplayed])
        [showStockGraph setState:NSOnState];
    else
        [showStockGraph setState:NSOffState];

    // Setup graph refresh
    [graphRefreshValue setTarget:self];
    [graphRefreshValue setAction:@selector(setGraphRefreshAction:)];
    [graphRefreshValue setFloatValue:[[xrgGraphWindow appSettings] graphRefresh]];
    
    float ref = [[xrgGraphWindow appSettings] graphRefresh];
    NSString *s;
    if (roundf(ref * 10.) == 10)
        s = @"Graph updates every second";
    else
        s = [[NSString alloc] initWithFormat: @"Graph updates every %2.1f seconds", ref];
        
    [graphRefreshText setStringValue:s];
    [s release];
    
    // Setup window level
    [windowLevel setTarget:xrgGraphWindow];
    [windowLevel setAction:@selector(setWindowLevel:)];
    [windowLevel removeAllItems];
    [windowLevel addItemWithTitle:@"Background"];
    [windowLevel addItemWithTitle:@"Normal"];
    [windowLevel addItemWithTitle:@"Foreground"];
    int selection = [[xrgGraphWindow appSettings] windowLevel];
    if (selection < -1 || selection > 1)
        [windowLevel selectItemAtIndex:1];
    else
        [windowLevel selectItemAtIndex:selection + 1];

    // Setup sticky window
    [stickyWindow setTarget:xrgGraphWindow];
    [stickyWindow setAction:@selector(setStickyWindow:)];
    if ([[xrgGraphWindow appSettings] stickyWindow]) 
        [stickyWindow setState:NSOnState];
    else
        [stickyWindow setState:NSOffState];

    // Setup check for updates
    [checkForUpdates setTarget:xrgGraphWindow];
    [checkForUpdates setAction:@selector(setCheckForUpdates:)];
    if ([[xrgGraphWindow appSettings] checkForUpdates])
        [checkForUpdates setState:NSOnState];
    else 
        [checkForUpdates setState:NSOffState];

    // Setup drop shadow
    [dropShadow setTarget:xrgGraphWindow];
    [dropShadow setAction:@selector(setDropShadow:)];
    if ([[xrgGraphWindow appSettings] dropShadow]) 
        [dropShadow setState:NSOnState];
    else
        [dropShadow setState:NSOffState];
        
    // Setup auto-expand graph
    [generalAutoExpandGraph setTarget:xrgGraphWindow];
    [generalAutoExpandGraph setAction:@selector(setAutoExpandGraph:)];
    if ([[xrgGraphWindow appSettings] autoExpandGraph])
        [generalAutoExpandGraph setState:NSOnState];
    else
        [generalAutoExpandGraph setState:NSOffState];
        
    // Setup foreground when expanding
    [generalForegroundWhenExpanding setTarget:xrgGraphWindow];
    [generalForegroundWhenExpanding setAction:@selector(setForegroundWhenExpanding:)];
    if ([[xrgGraphWindow appSettings] foregroundWhenExpanding])
        [generalForegroundWhenExpanding setState:NSOnState];
    else
        [generalForegroundWhenExpanding setState:NSOffState];
        
    // Setup show summary
    [generalShowSummary setTarget:xrgGraphWindow];
    [generalShowSummary setAction:@selector(setShowSummary:)];
    if ([[xrgGraphWindow appSettings] showSummary])
        [generalShowSummary setState:NSOnState];
    else
        [generalShowSummary setState:NSOffState];
        
    // Setup minimize up/down
    [generalMinimizeUpDown setTarget:xrgGraphWindow];
    [generalMinimizeUpDown setAction:@selector(setMinimizeUpDown:)];
    [generalMinimizeUpDown removeAllItems];
    [generalMinimizeUpDown addItemWithTitle:@"Up/Left"];
    [generalMinimizeUpDown addItemWithTitle:@"Down/Right"];
    selection = [[xrgGraphWindow appSettings] minimizeUpDown];
    if (selection < 0 || selection > 1)
        [generalMinimizeUpDown selectItemAtIndex:0];
    else
        [generalMinimizeUpDown selectItemAtIndex:selection];    
        
    return;
}

- (void)setUpColorPanel {
    [self setUpWell:backgroundColorWell withTransparency:backgroundTransparency];
    [self setUpWell:graphBGColorWell    withTransparency:graphBGTransparency];
    [self setUpWell:graphFG1ColorWell   withTransparency:graphFG1Transparency];
    [self setUpWell:graphFG2ColorWell   withTransparency:graphFG2Transparency];
    [self setUpWell:graphFG3ColorWell   withTransparency:graphFG3Transparency];
    [self setUpWell:borderColorWell     withTransparency:borderTransparency];
    [self setUpWell:textColorWell       withTransparency:textTransparency];
    
    [font setTarget:self];
    [font setAction:@selector(setFont:)];
    
    [appearanceAntialiasText setTarget:xrgGraphWindow];
    [appearanceAntialiasText setAction:@selector(setAntialiasText:)];
    if ([[xrgGraphWindow appSettings] antialiasText])
        [appearanceAntialiasText setState:NSOnState];
    else 
        [appearanceAntialiasText setState:NSOffState];
}

- (void)setUpCPUPanel {
    // Setup fast CPU usage checkbox
    [fastCPUUsageCheckbox setTarget:xrgGraphWindow];
    [fastCPUUsageCheckbox setAction:@selector(setFastCPUUsageCheckbox:)];
    if ([[xrgGraphWindow appSettings] fastCPUUsage]) 
        [fastCPUUsageCheckbox setState:NSOnState];
    else
        [fastCPUUsageCheckbox setState:NSOffState];

    // Setup separate CPU color
    [separateCPUColor setTarget:xrgGraphWindow];
    [separateCPUColor setAction:@selector(setSeparateCPUColor:)];
    if ([[xrgGraphWindow appSettings] separateCPUColor]) 
        [separateCPUColor setState:NSOnState];
    else
        [separateCPUColor setState:NSOffState];

    // Setup show CPU temperature
    [showCPUTemperature setTarget:xrgGraphWindow];
    [showCPUTemperature setAction:@selector(setShowCPUTemperature:)];
    if ([[xrgGraphWindow appSettings] showCPUTemperature]) 
        [showCPUTemperature setState:NSOnState];
    else
        [showCPUTemperature setState:NSOffState];
        
    [cpuTemperatureUnits setTarget:xrgGraphWindow];
    [cpuTemperatureUnits setAction:@selector(setCPUTemperatureUnits:)];
    [cpuTemperatureUnits selectItemAtIndex:[[xrgGraphWindow appSettings] cpuTemperatureUnits]];

    // Setup show load average
    [showLoadAverage setTarget:xrgGraphWindow];
    [showLoadAverage setAction:@selector(setShowLoadAverage:)];
    if ([[xrgGraphWindow appSettings] showLoadAverage]) 
        [showLoadAverage setState:NSOnState];
    else
        [showLoadAverage setState:NSOffState];
        
    // Setup show average cpu usage
    [cpuShowAverageUsage setTarget:xrgGraphWindow];
    [cpuShowAverageUsage setAction:@selector(setCPUShowAverageUsage:)];
    if ([[xrgGraphWindow appSettings] cpuShowAverageUsage]) 
        [cpuShowAverageUsage setState:NSOnState];
    else
        [cpuShowAverageUsage setState:NSOffState];

    // Setup show uptime
    [cpuShowUptime setTarget:xrgGraphWindow];
    [cpuShowUptime setAction:@selector(setCPUShowUptime:)];
    if ([[xrgGraphWindow appSettings] cpuShowUptime]) 
        [cpuShowUptime setState:NSOnState];
    else
        [cpuShowUptime setState:NSOffState];
}

- (void)setUpMemoryPanel {
    [memoryShowWired       setTarget:xrgGraphWindow];
    [memoryShowActive      setTarget:xrgGraphWindow];
    [memoryShowInactive    setTarget:xrgGraphWindow];
    [memoryShowFree        setTarget:xrgGraphWindow];
    [memoryShowCache       setTarget:xrgGraphWindow];
    [memoryShowPage        setTarget:xrgGraphWindow];
    [memoryShowPagingGraph setTarget:xrgGraphWindow];
    
    [memoryShowWired       setAction:@selector(setMemoryCheckbox:)];
    [memoryShowActive      setAction:@selector(setMemoryCheckbox:)];
    [memoryShowInactive    setAction:@selector(setMemoryCheckbox:)];
    [memoryShowFree        setAction:@selector(setMemoryCheckbox:)];
    [memoryShowCache       setAction:@selector(setMemoryCheckbox:)];
    [memoryShowPage        setAction:@selector(setMemoryCheckbox:)];
    [memoryShowPagingGraph setAction:@selector(setMemoryCheckbox:)];
        
    if ([[xrgGraphWindow appSettings] memoryShowWired])
        [memoryShowWired setState:NSOnState];
    else
        [memoryShowWired setState:NSOffState];
        
    if ([[xrgGraphWindow appSettings] memoryShowActive])
        [memoryShowActive setState:NSOnState];
    else
        [memoryShowActive setState:NSOffState];
        
    if ([[xrgGraphWindow appSettings] memoryShowInactive])
        [memoryShowInactive setState:NSOnState];
    else
        [memoryShowInactive setState:NSOffState];
        
    if ([[xrgGraphWindow appSettings] memoryShowFree])
        [memoryShowFree setState:NSOnState];
    else
        [memoryShowFree setState:NSOffState];
        
    if ([[xrgGraphWindow appSettings] memoryShowCache])
        [memoryShowCache setState:NSOnState];
    else
        [memoryShowCache setState:NSOffState];
        
    if ([[xrgGraphWindow appSettings] memoryShowPage])
        [memoryShowPage setState:NSOnState];
    else
        [memoryShowPage setState:NSOffState];
        
    if ([[xrgGraphWindow appSettings] showMemoryPagingGraph])
        [memoryShowPagingGraph setState:NSOnState];
    else
        [memoryShowPagingGraph setState:NSOffState];
}

- (void)setUpTemperaturePanel {
    [tempUnits setTarget:xrgGraphWindow];
    [tempFG1Location setTarget:xrgGraphWindow];
    [tempFG2Location setTarget:xrgGraphWindow];
    [tempFG3Location setTarget:xrgGraphWindow];
    
    [tempUnits setAction:@selector(setTempUnits:)];
    [tempFG1Location setAction:@selector(setTempFG1Location:)];
    [tempFG2Location setAction:@selector(setTempFG2Location:)];
    [tempFG3Location setAction:@selector(setTempFG3Location:)];
    
    [tempUnits removeAllItems];
    [tempUnits addItemWithTitle:@"Fahrenheit"];
    [tempUnits addItemWithTitle:@"Celsius"];
    [tempUnits selectItemAtIndex:[[xrgGraphWindow appSettings] tempUnits]];
	
    [tempFG1Location removeAllItems];
    [tempFG2Location removeAllItems];
    [tempFG3Location removeAllItems];
    
    if ([xrgGraphWindow temperatureMiner]) {
        NSArray *locations = [[xrgGraphWindow temperatureMiner] locationKeysInOrder];
        int numLocations = [locations count];
		
        if (numLocations > 0) {
            [tempFG1Location addItemWithTitle:@"None"];
            [tempFG2Location addItemWithTitle:@"None"];
            [tempFG3Location addItemWithTitle:@"None"];
        
            [tempFG1Location addItemsWithTitles:locations];
            [tempFG2Location addItemsWithTitles:locations];
            [tempFG3Location addItemsWithTitles:locations];

			int temp1Index = [[xrgGraphWindow appSettings] tempFG1Location];
			int temp2Index = [[xrgGraphWindow appSettings] tempFG2Location];
			int temp3Index = [[xrgGraphWindow appSettings] tempFG3Location];
			if (temp1Index < 0 | temp1Index >= numLocations) temp1Index = 0;
			if (temp2Index < 0 | temp2Index >= numLocations) temp2Index = 0;
			if (temp3Index < 0 | temp3Index >= numLocations) temp3Index = 0;
			
            [tempFG1Location selectItemAtIndex:temp1Index];
            [tempFG2Location selectItemAtIndex:temp2Index];
            [tempFG3Location selectItemAtIndex:temp3Index];
        }
        else {
            [tempFG1Location addItemWithTitle:@"No Sensors Found"];
            [tempFG2Location addItemWithTitle:@"No Sensors Found"];
            [tempFG3Location addItemWithTitle:@"No Sensors Found"];
        }
    }
    else {
        [tempFG1Location addItemWithTitle:@"No Sensors Found"];
        [tempFG2Location addItemWithTitle:@"No Sensors Found"];
        [tempFG3Location addItemWithTitle:@"No Sensors Found"];
    }
}

- (void)setUpNetworkPanel {
    // Setup net min graph
    [netMinGraphScaleUnits setTarget:self];
    [netMinGraphScaleValue setTarget:self];
    [netMinGraphScaleUnits setAction:@selector(setNetMinGraphUnitsAction:)];
    [netMinGraphScaleValue setAction:@selector(setNetMinGraphValueAction:)];
    
    NSString *s;
    int minByteScale = [[xrgGraphWindow appSettings] netMinGraphScale];
    if (minByteScale < 1024) {
        [netMinGraphScaleUnits selectItemAtIndex:0];
        s = [[NSString alloc] initWithFormat: @"%d", minByteScale];
        [netMinGraphScaleValue setStringValue:s];
    }
    else if (minByteScale < 1048576) {
        [netMinGraphScaleUnits selectItemAtIndex:1];
        s = [[NSString alloc] initWithFormat: @"%d", minByteScale / 1024];
        [netMinGraphScaleValue setStringValue:s];
    }
    else {
        [netMinGraphScaleUnits selectItemAtIndex:2];
        s = [[NSString alloc] initWithFormat: @"%d", minByteScale / 1048576];
        [netMinGraphScaleValue setStringValue:s];
    }
    [s release];
    
    // Setup net graph mode
    [netGraphMode setTarget:xrgGraphWindow];
    [netGraphMode setAction:@selector(setNetGraphMode:)];
    [netGraphMode selectCellAtRow: [[xrgGraphWindow appSettings] netGraphMode] column:0];
    
    // Setup show total bandwidth
    [showTotalBandwidthSinceBoot setTarget:xrgGraphWindow];
    [showTotalBandwidthSinceBoot setAction:@selector(setShowTotalBandwidthSinceBoot:)];
    if ([[xrgGraphWindow appSettings] showTotalBandwidthSinceBoot])
        [showTotalBandwidthSinceBoot setState:NSOnState];
    else
        [showTotalBandwidthSinceBoot setState:NSOffState];
        
    [showTotalBandwidthSinceLoad setTarget:xrgGraphWindow];
    [showTotalBandwidthSinceLoad setAction:@selector(setShowTotalBandwidthSinceLoad:)];
    if ([[xrgGraphWindow appSettings] showTotalBandwidthSinceLoad])
        [showTotalBandwidthSinceLoad setState:NSOnState];
    else
        [showTotalBandwidthSinceLoad setState:NSOffState];
        
    // Setup network interface to monitor
    [networkInterface setTarget:xrgGraphWindow];
    [networkInterface setAction:@selector(setNetworkInterface:)];
    [networkInterface removeAllItems];
    [networkInterface addItemWithTitle:@"All Active"];
    NSArray *interfaces = [[xrgGraphWindow netView] networkInterfaces];
    NSString *selectedInterface = [[xrgGraphWindow appSettings] networkInterface];
    int i;
    for (i = 0; i < [interfaces count]; i++) {
        [networkInterface addItemWithTitle:[interfaces objectAtIndex:i]];
        
        if ([selectedInterface isEqualToString:[interfaces objectAtIndex:i]])
            [networkInterface selectItemAtIndex:(i + 1)];
    }
}

- (void)setUpDiskPanel {
    // Setup disk graph mode
    [diskGraphMode setTarget:xrgGraphWindow];
    [diskGraphMode setAction:@selector(setDiskGraphMode:)];
    [diskGraphMode selectCellAtRow: [[xrgGraphWindow appSettings] diskGraphMode] column:0];
}

- (void)setUpWeatherPanel {
    int selection;
    
    // Setup ICAO
    [ICAOCode setTarget:xrgGraphWindow];
    [ICAOCode setAction:@selector(setICAO:)];
    if ([[xrgGraphWindow appSettings] ICAO] != nil)
        [ICAOCode setStringValue:[[xrgGraphWindow appSettings] ICAO]];
    else
        [ICAOCode setStringValue:@""];
        
    // Setup station list link
    NSString *htmlString = @"<a href=\"http://adds.aviationweather.noaa.gov/metars/stations.txt\">Station Listing</a>";
	const char *cString = [htmlString cStringUsingEncoding:NSASCIIStringEncoding];
	[weatherStationListLink setAttributedTitle:[[[NSAttributedString alloc] initWithHTML:[NSData dataWithBytes:cString length:strlen(cString)] documentAttributes:nil] autorelease]];
    [weatherStationListLink setTarget:self];
    [weatherStationListLink setAction:@selector(openWeatherStationList:)];

    
    // Setup secondary weather graph
    [secondaryWeatherGraph setTarget:xrgGraphWindow];
    [secondaryWeatherGraph setAction:@selector(setSecondaryWeatherGraph:)];
    
    NSArray *items = [[xrgGraphWindow weatherView] getSecondaryGraphList];
    [secondaryWeatherGraph removeAllItems];
    int i;
    for (i = 0; i < [items count]; i++) {
        [secondaryWeatherGraph addItemWithTitle: [items objectAtIndex:i]];
    }
    selection = [[xrgGraphWindow appSettings] secondaryWeatherGraph];
    if (selection < 0 || selection >= [secondaryWeatherGraph numberOfItems])
        [secondaryWeatherGraph selectItemAtIndex:0];
    else
        [secondaryWeatherGraph selectItemAtIndex:selection];

    // Setup temperature units
    [temperatureUnits setTarget:xrgGraphWindow];
    [temperatureUnits setAction:@selector(setTemperatureUnits:)];
    
    [temperatureUnits removeAllItems];
    [temperatureUnits addItemWithTitle:@"Fahrenheit"];
    [temperatureUnits addItemWithTitle:@"Celsius"];
    
    selection = [[xrgGraphWindow appSettings] temperatureUnits];
    if (selection < 0 || selection > 1)
        [temperatureUnits selectItemAtIndex:0];
    else
        [temperatureUnits selectItemAtIndex:selection];

    // Setup distance Units
    [distanceUnits setTarget:xrgGraphWindow];
    [distanceUnits setAction:@selector(setDistanceUnits:)];
    
    [distanceUnits removeAllItems];
    [distanceUnits addItemWithTitle:@"Miles"];
    [distanceUnits addItemWithTitle:@"Kilometers"];
    
    selection = [[xrgGraphWindow appSettings] distanceUnits];
    if (selection < 0 || selection > 1) 
        [distanceUnits selectItemAtIndex:0];
    else
        [distanceUnits selectItemAtIndex:selection];
    
    // Setup pressure units
    [pressureUnits setTarget:xrgGraphWindow];
    [pressureUnits setAction:@selector(setPressureUnits:)];
    
    [pressureUnits removeAllItems];
    [pressureUnits addItemWithTitle:@"Inches"];
    [pressureUnits addItemWithTitle:@"Hectopascals"];
    
    selection = [[xrgGraphWindow appSettings] pressureUnits];
    if (selection < 0 || selection > 1) 
        [pressureUnits selectItemAtIndex:0];
    else
        [pressureUnits selectItemAtIndex:selection];
}

- (void)setUpStockPanel {
    [stockSymbols setTarget:xrgGraphWindow];
    [stockSymbols setAction:@selector(setStockSymbols:)];
    if ([[xrgGraphWindow appSettings] stockSymbols] != nil)
        [stockSymbols setStringValue:[[xrgGraphWindow appSettings] stockSymbols]];
    else
        [stockSymbols setStringValue:@""];
        
    [stockGraphTimeFrame setTarget:xrgGraphWindow];
    [stockGraphTimeFrame setAction:@selector(setStockGraphTimeFrame:)];
    
    [stockGraphTimeFrame removeAllItems];
    [stockGraphTimeFrame addItemWithTitle:@"1 Month"];
    [stockGraphTimeFrame addItemWithTitle:@"3 Months"];
    [stockGraphTimeFrame addItemWithTitle:@"6 Months"];
    [stockGraphTimeFrame addItemWithTitle:@"12 Months"];
    
    int selection = [[xrgGraphWindow appSettings] stockGraphTimeFrame];
    if (selection < 0 || selection > 3)
        [stockGraphTimeFrame selectItemAtIndex:0];
    else
        [stockGraphTimeFrame selectItemAtIndex:selection];
    
    [stockShowChange setTarget:xrgGraphWindow];
    [stockShowChange setAction:@selector(setStockShowChange:)];
    
    if ([[xrgGraphWindow appSettings] stockShowChange])
        [stockShowChange setState:NSOnState];
    else
        [stockShowChange setState:NSOffState];
        
    [showDJIA setTarget:xrgGraphWindow];
    [showDJIA setAction:@selector(setShowDJIA:)];
    
    if ([[xrgGraphWindow appSettings] showDJIA])
        [showDJIA setState:NSOnState];
    else
        [showDJIA setState:NSOffState];
}

- (IBAction)loadTheme:(id)sender {                   
    NSArray *fileTypes = [NSArray arrayWithObject:@"xtf"];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];

    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setCanChooseFiles:YES];
    [oPanel beginSheetForDirectory:NSHomeDirectory() 
                              file:@"" 
                             types:fileTypes 
                    modalForWindow:window 
                     modalDelegate:self 
                    didEndSelector:@selector(loadTheme2:returnCode:contextInfo:) 
                       contextInfo:nil];
}

- (void)loadTheme2:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo {
    ;
    NSData *themeData;
    NSString *error;        
    NSPropertyListFormat format;
    NSDictionary *themeDictionary;
    
    /* if successful, open file under designated name */
    if (returnCode == NSOKButton) {
        NSArray *filenames = [sheet URLs];
        NSURL *path = [filenames objectAtIndex:0];

        themeData = [NSData dataWithContentsOfURL:path];
        
        if ([themeData length] == 0) {
            NSRunInformationalAlertPanel(@"Error", @"The theme file specified is not a valid theme file.", @"Okay", nil, nil);
        }

        themeDictionary = [NSPropertyListSerialization propertyListFromData:themeData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:&format
                                                           errorDescription:&error];
                                                           
        if (!themeDictionary) {
            NSRunInformationalAlertPanel(@"Error", @"The theme file specified is not a valid theme file.", @"Okay", nil, nil);
            NSLog(@"%@", error);
            [error release];
        }
        else {
            @try {
                NSData *d = [themeDictionary objectForKey:XRG_backgroundColor];
                [backgroundColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                d = [themeDictionary objectForKey:XRG_graphBGColor];
                [graphBGColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                d = [themeDictionary objectForKey:XRG_graphFG1Color];
                [graphFG1ColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                d = [themeDictionary objectForKey:XRG_graphFG2Color];
                [graphFG2ColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                d = [themeDictionary objectForKey:XRG_graphFG3Color];
                [graphFG3ColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                d = [themeDictionary objectForKey:XRG_borderColor];
                [borderColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                d = [themeDictionary objectForKey:XRG_textColor];
                [textColorWell setColor:[NSUnarchiver unarchiveObjectWithData:d]];
                
                NSNumber *n = (NSNumber *)[themeDictionary objectForKey:XRG_backgroundTransparency];
                [backgroundTransparency setFloatValue: [n floatValue]];
                
                n = (NSNumber *)[themeDictionary objectForKey:XRG_graphBGTransparency];
                [graphBGTransparency setFloatValue:    [n floatValue]];
                
                n = (NSNumber *)[themeDictionary objectForKey:XRG_graphFG1Transparency];
                [graphFG1Transparency setFloatValue:   [n floatValue]];
                
                n = (NSNumber *)[themeDictionary objectForKey:XRG_graphFG2Transparency];
                [graphFG2Transparency setFloatValue:   [n floatValue]];
                
                n = (NSNumber *)[themeDictionary objectForKey:XRG_graphFG3Transparency];
                [graphFG3Transparency setFloatValue:   [n floatValue]];
                
                n = (NSNumber *)[themeDictionary objectForKey:XRG_borderTransparency];
                [borderTransparency setFloatValue:     [n floatValue]];
                
                n = (NSNumber *)[themeDictionary objectForKey:XRG_textTransparency];
                [textTransparency setFloatValue:       [n floatValue]];
                
                [xrgGraphWindow setObjectsToColor:backgroundColorWell];
                [xrgGraphWindow setObjectsToColor:graphBGColorWell];
                [xrgGraphWindow setObjectsToColor:graphFG1ColorWell];
                [xrgGraphWindow setObjectsToColor:graphFG2ColorWell];
                [xrgGraphWindow setObjectsToColor:graphFG3ColorWell];
                [xrgGraphWindow setObjectsToColor:borderColorWell];
                [xrgGraphWindow setObjectsToColor:textColorWell];
    
                [xrgGraphWindow setObjectsToTransparency:backgroundTransparency];
                [xrgGraphWindow setObjectsToTransparency:graphBGTransparency];
                [xrgGraphWindow setObjectsToTransparency:graphFG1Transparency];
                [xrgGraphWindow setObjectsToTransparency:graphFG2Transparency];
                [xrgGraphWindow setObjectsToTransparency:graphFG3Transparency];
                [xrgGraphWindow setObjectsToTransparency:borderTransparency];
                [xrgGraphWindow setObjectsToTransparency:textTransparency];
            } @catch (NSException *e) {
                NSRunInformationalAlertPanel(@"Error", @"The theme file specified is not a valid theme file.", @"Okay", nil, nil);
            }
        }
    }
}

- (IBAction)saveTheme:(id)sender {
    NSSavePanel *sp = [NSSavePanel savePanel];
    
    [sp setAllowedFileTypes:[NSArray arrayWithObject:@"xtf"]];
    /* display the NSSavePanel */
    [sp beginSheetForDirectory:NSHomeDirectory() 
                          file:@"My Theme.xtf" 
                modalForWindow:window 
                 modalDelegate:self 
                didEndSelector:@selector(saveTheme2:returnCode:contextInfo:) 
                   contextInfo:nil];
}
    
- (void)saveTheme2:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo {
    NSData *xmlData;
    NSString *error;        
    
    /* if successful, save file under designated name */
    if (returnCode == NSOKButton) {
        NSURL *path = [sheet URL];
        
        // Create the property dictionary
        NSMutableDictionary *colorPrefs = [NSMutableDictionary dictionary];

        [colorPrefs setObject:[NSNumber numberWithFloat:[backgroundTransparency floatValue]]
                       forKey:XRG_backgroundTransparency];
        [colorPrefs setObject:[NSNumber numberWithFloat:[graphBGTransparency floatValue]]
                       forKey:XRG_graphBGTransparency];
        [colorPrefs setObject:[NSNumber numberWithFloat:[graphFG1Transparency floatValue]]
                       forKey:XRG_graphFG1Transparency];
        [colorPrefs setObject:[NSNumber numberWithFloat:[graphFG2Transparency floatValue]]
                       forKey:XRG_graphFG2Transparency];
        [colorPrefs setObject:[NSNumber numberWithFloat:[graphFG3Transparency floatValue]]
                       forKey:XRG_graphFG3Transparency];
        [colorPrefs setObject:[NSNumber numberWithFloat:[borderTransparency floatValue]]
                       forKey:XRG_borderTransparency];
        [colorPrefs setObject:[NSNumber numberWithFloat:[textTransparency floatValue]]
                       forKey:XRG_textTransparency];
        
                //[NSArchiver archivedDataWithRootObject:[c copy]]

        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[backgroundColorWell color]] 
                       forKey:XRG_backgroundColor];
        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[graphBGColorWell color]]
                       forKey:XRG_graphBGColor];
        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[graphFG1ColorWell color]]
                       forKey:XRG_graphFG1Color];
        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[graphFG2ColorWell color]]
                       forKey:XRG_graphFG2Color];
        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[graphFG3ColorWell color]]
                       forKey:XRG_graphFG3Color];
        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[borderColorWell color]]
                       forKey:XRG_borderColor];
        [colorPrefs setObject:[NSArchiver archivedDataWithRootObject:[textColorWell color]]
                       forKey:XRG_textColor];
                    
        xmlData = [NSPropertyListSerialization dataFromPropertyList:colorPrefs
                                                             format:NSPropertyListXMLFormat_v1_0
                                                   errorDescription:&error];
        if (xmlData) {
            if (![xmlData writeToURL:path atomically:YES]) {
                NSRunInformationalAlertPanel(@"Error", @"Could not save the theme to that location.", @"Okay", nil, nil);
            }
        }
        else {
            NSLog(@"%@", error);
            [error release];
        }
    }
}

- (NSWindow *)window {
    return window;
}

- (void)setUpWell:(NSColorWell *)well withTransparency:(NSSlider *)tSlider {
    [well setTarget:xrgGraphWindow];
    [well setAction:@selector(setObjectsToColor:)];
    [well setColor:[xrgGraphWindow colorForTag:[well tag]]];
    
    [tSlider setTarget:xrgGraphWindow];
    [tSlider setAction:@selector(setObjectsToTransparency:)];
    [tSlider setFloatValue:[xrgGraphWindow transparencyForTag:[tSlider tag]]];
}

- (IBAction)setGraphRefreshAction:(id)sender {
    float ref = [sender floatValue];
	ref = roundf(ref * 5.) * 0.2;
	
    NSString *s;
    if (roundf(ref * 10.) == 10) 
        s = @"Graph updates every second";
    else
        s = [[NSString alloc] initWithFormat: @"Graph updates every %2.1f seconds", ref];
    
    [graphRefreshText setStringValue:s];
    [s release];

    [xrgGraphWindow setGraphRefreshActionPart2:sender];
}

- (void)setUpModuleSelection {
}

- (IBAction)setNetMinGraphUnitsAction:(id)sender {
    int sInt = [[netMinGraphScaleValue stringValue] intValue];
    if (sInt == INT_MAX || sInt == INT_MIN) {
        NSBeginAlertSheet(@"Error", @"OK", nil, nil, window, nil, nil, nil, nil, @"The minimum network scale must be a number.");
        [netMinGraphScaleValue setStringValue:@"0"];
        return;
    }
    if (sInt == 0) {
        if (![[netMinGraphScaleValue stringValue] isEqualToString:@"0"]) {
            NSBeginAlertSheet(@"Error", @"OK", nil, nil, window, nil, nil, nil, nil, @"The minimum network scale must be a number.");            
            [netMinGraphScaleValue setStringValue:@"0"];
            return;
        }
    }

    if ([sender indexOfSelectedItem] == 0)
        [[xrgGraphWindow appSettings] setNetMinGraphScale:sInt];
    else if ([sender indexOfSelectedItem] == 1) 
        [[xrgGraphWindow appSettings] setNetMinGraphScale:sInt * 1024];
    else
        [[xrgGraphWindow appSettings] setNetMinGraphScale:sInt * 1048576];
}

- (IBAction)setNetMinGraphValueAction:(id)sender {
    NSString *s = [sender stringValue];
    int sInt = [s intValue];
    if (sInt == INT_MAX || sInt == INT_MIN) {
        NSBeginAlertSheet(@"Error", @"OK", nil, nil, window, nil, nil, nil, nil, @"The minimum network scale must be a number.");
        [netMinGraphScaleValue setStringValue:@"0"];
        return;
    }
    if (sInt == 0) {
        if (![s isEqualToString:@"0"]) {
            NSBeginAlertSheet(@"Error", @"OK", nil, nil, window, nil, nil, nil, nil, @"The minimum network scale must be a number.");            
            [netMinGraphScaleValue setStringValue:@"0"];
            return;
        }
    }
    
    if ([netMinGraphScaleUnits indexOfSelectedItem] == 0)
        [[xrgGraphWindow appSettings] setNetMinGraphScale:sInt];
    else if ([netMinGraphScaleUnits indexOfSelectedItem] == 1) 
        [[xrgGraphWindow appSettings] setNetMinGraphScale:sInt * 1024];
    else
        [[xrgGraphWindow appSettings] setNetMinGraphScale:sInt * 1048576];
}

- (NSColorWell *)colorWellForTag:(int)aTag {
    return [[window contentView] viewWithTag:aTag];
}

- (IBAction)setFont:(id)sender {
    [[NSFontPanel sharedFontPanel] makeKeyAndOrderFront:self];
    [[NSFontManager sharedFontManager] setSelectedFont:[[xrgGraphWindow appSettings] graphFont] isMultiple:NO];
}

// Here are the action methods for the toolbar buttons.

// This method will change the window size from one view to another and display the new view.
-(void) switchWindowFromView:oldView toView:newView {
    NSRect newWindowSize = [newView frame];
    newWindowSize.origin.x = [window frame].origin.x;
    newWindowSize.origin.y = [window frame].origin.y + [oldView frame].size.height - newWindowSize.size.height;
    newWindowSize.size.height = [window frame].size.height - [oldView frame].size.height + newWindowSize.size.height;

    NSRect oldViewSize = [oldView frame];
    
    [oldView removeFromSuperview];
    [window setFrame:newWindowSize display:YES animate:YES];
    [window setContentView:newView];
    [oldView setFrameSize:oldViewSize.size];
}

-(IBAction) General:(id)sender {
    if (currentView != GeneralPrefView) {
        [self switchWindowFromView:currentView toView:GeneralPrefView];
        currentView = GeneralPrefView;
		[window setTitle:@"General Preferences"];
		[toolbar setSelectedItemIdentifier:@"General"];
    }
}

-(IBAction) Colors:(id)sender {
    if (currentView != ColorPrefView) {
        [self switchWindowFromView:currentView toView:ColorPrefView];
        currentView = ColorPrefView;
		[window setTitle:@"Appearance Preferences"];
		[toolbar setSelectedItemIdentifier:@"Appearance"];
    }
}

-(IBAction) CPU:(id)sender {
    if (currentView != CPUPrefView) {
        [self switchWindowFromView:currentView toView:CPUPrefView];
        currentView = CPUPrefView;
		[window setTitle:@"CPU Preferences"];
		[toolbar setSelectedItemIdentifier:@"CPU"];
    }
}

-(IBAction) RAM:(id)sender {
    if (currentView != MemoryPrefView) {
        [self switchWindowFromView:currentView toView:MemoryPrefView];
        currentView = MemoryPrefView;
 		[window setTitle:@"Memory Preferences"];
		[toolbar setSelectedItemIdentifier:@"RAM"];
   }
}

-(IBAction) Temperature:(id)sender {
    if (currentView != TemperaturePrefView) {
        [self switchWindowFromView:currentView toView:TemperaturePrefView];
        currentView = TemperaturePrefView;
		[window setTitle:@"Temperature Preferences"];
		[toolbar setSelectedItemIdentifier:@"Temperature"];
    }
}

-(IBAction) Network:(id)sender {
    if (currentView != NetworkPrefView) {
        [self switchWindowFromView:currentView toView:NetworkPrefView];
        currentView = NetworkPrefView;
		[window setTitle:@"Network Preferences"];
		[toolbar setSelectedItemIdentifier:@"Network"];
    }
}

-(IBAction) Disk:(id)sender {
    if (currentView != DiskPrefView) {
        [self switchWindowFromView:currentView toView:DiskPrefView];
        currentView = DiskPrefView;
		[window setTitle:@"Disk Preferences"];
		[toolbar setSelectedItemIdentifier:@"Disk"];
    }
}

-(IBAction) Weather:(id)sender {
    if (currentView != WeatherPrefView) {
        [self switchWindowFromView:currentView toView:WeatherPrefView];
        currentView = WeatherPrefView;
		[window setTitle:@"Weather Preferences"];
		[toolbar setSelectedItemIdentifier:@"Weather"];
    }
}

-(IBAction) Stocks:(id)sender {
    if (currentView != StockPrefView) {
        [self switchWindowFromView:currentView toView:StockPrefView];
        currentView = StockPrefView;
		[window setTitle:@"Stock Preferences"];
 		[toolbar setSelectedItemIdentifier:@"Stock"];
	}
}

-(IBAction) openWeatherStationList:(id)sender {
    [NSTask 
        launchedTaskWithLaunchPath:@"/usr/bin/open"
        arguments:[NSArray arrayWithObject:@"http://adds.aviationweather.noaa.gov/metars/stations.txt"]
    ];
}

// These last methods are required for the toolbar

// This method is required of NSToolbar delegates.  It takes an identifier, and returns the matching NSToolbarItem.
// It also takes a parameter telling whether this toolbar item is going into an actual toolbar, or whether it's
// going to be displayed in a customization palette.
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    // We create and autorelease a new NSToolbarItem, and then go through the process of setting up its
    // attributes from the master toolbar item matching that identifier in our dictionary of items.
    NSToolbarItem *newItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
    NSToolbarItem *item=[toolbarItems objectForKey:itemIdentifier];
    
    [newItem setLabel:[item label]];
    [newItem setPaletteLabel:[item paletteLabel]];
    if ([item view] != NULL) {
	[newItem setView:[item view]];
    }
    else {
	[newItem setImage:[item image]];
    }
    [newItem setToolTip:[item toolTip]];
    [newItem setTarget:[item target]];
    [newItem setAction:[item action]];
    [newItem setMenuFormRepresentation:[item menuFormRepresentation]];
    // If we have a custom view, we *have* to set the min/max size - otherwise, it'll default to 0,0 and the custom
    // view won't show up at all!  This doesn't affect toolbar items with images, however.
    if ([newItem view] != NULL) {
	[newItem setMinSize:[[item view] bounds].size];
	[newItem setMaxSize:[[item view] bounds].size];
    }

    return newItem;
}

// This method is required of NSToolbar delegates.  It returns an array holding identifiers for the default
// set of toolbar items.  It can also be called by the customization palette to display the default toolbar.    
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
    return [NSArray arrayWithObjects:@"General", @"Appearance", @"CPU", @"RAM", @"Temperature", @"Network", @"Disk", @"Weather", @"Stocks", nil];
}

// This method is required of NSToolbar delegates.  It returns an array holding identifiers for all allowed
// toolbar items in this toolbar.  Any not listed here will not be available in the customization palette.
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
    return [NSArray arrayWithObjects:@"General", @"Appearance", @"CPU", @"RAM", @"Temperature", @"Network", @"Disk", @"Weather", @"Stocks", nil];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar*)toolbar {
    return [NSArray arrayWithObjects:@"General", @"Appearance", @"CPU", @"RAM", @"Temperature", @"Network", @"Disk", @"Weather", @"Stocks", nil];
}

- (void) windowWillClose:(NSNotification *)aNotification {
	[self save:self];
}

@end