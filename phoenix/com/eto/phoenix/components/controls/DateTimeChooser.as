////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2003-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.eto.phoenix.components.controls
{

import com.eto.phoenix.components.controls.dateChooser.TimeInputNumericStepper;

import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.events.Event;
import flash.geom.Matrix;

import mx.controls.CalendarLayout;
import mx.controls.ComboBox;
import mx.controls.NumericStepper;
import mx.core.IFlexModuleFactory;
import mx.core.IFontContextComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CalendarLayoutChangeEvent;
import mx.events.DateChooserEvent;
import mx.events.DropdownEvent;
import mx.events.FlexEvent;
import mx.events.NumericStepperEvent;
import mx.graphics.RectangularDropShadow;
import mx.managers.IFocusManagerComponent;
import mx.styles.StyleManager;
import mx.styles.StyleProxy;
import mx.utils.GraphicsUtil;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when a date is selected or changed.
 *
 *  @eventType mx.events.CalendarLayoutChangeEvent.CHANGE
 *  @helpid 3601
 *  @tiptext change event
 */
[Event(name="change", type="mx.events.CalendarLayoutChangeEvent")]

/**
 *  Dispatched when the month changes due to user interaction.
 *
 *  @eventType mx.events.DateChooserEvent.SCROLL
 *  @helpid 3600
 *  @tiptext scroll event
 */
[Event(name="scroll", type="mx.events.DateChooserEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Alpha level of the color defined by the <code>backgroundColor</code>
 *  property.
 *  Valid values range from 0.0 to 1.0.
 *  @default 1.0
 */
[Style(name="backgroundAlpha", type="Number", inherit="no")]

/**
 *  Background color of the DateChooser control.
 *  
 *  @default 0xFFFFF
 */
[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

/**
 *  Color of the border.
 *  The following controls support this style: Button, CheckBox,
 *  ComboBox, MenuBar,
 *  NumericStepper, ProgressBar, RadioButton, ScrollBar, Slider, and any
 *  components that support the <code>borderStyle</code> style.
 *  The default value depends on the component class;
 *  if not overriden for the class, the default value is <code>0xB7BABC</code>.
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no")]

/**
 *  Bounding box thickness.
 *  Only used when <code>borderStyle</code> is set to <code>"solid"</code>.
 *  @default 1
 */
[Style(name="borderThickness", type="Number", format="Length", inherit="no")]

/**
 *  Radius of component corners.
 *  The following components support this style: Alert, Button, ComboBox,  
 *  LinkButton, MenuBar, NumericStepper, Panel, ScrollBar, Tab, TitleWindow, 
 *  and any component
 *  that supports a <code>borderStyle</code> property set to <code>"solid"</code>.
 *  The default value depends on the component class;
 *  if not overriden for the class, the default value is <code>0</code>.
 */
[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]

/**
 *  Alphas used for the background fill of controls. Use [1, 1] to make the control background
 *  opaque.
 *  
 *  @default [ 0.6, 0.4 ]
 */
[Style(name="fillAlphas", type="Array", arrayType="Number", inherit="no")]

/**
 *  Colors used to tint the background of the control.
 *  Pass the same color for both values for a flat-looking control.
 *  
 *  @default [ 0xFFFFFF, 0xCCCCCC ]
 */
[Style(name="fillColors", type="Array", arrayType="uint", format="Color", inherit="no")]

/**
 *  Colors of the band at the top of the DateChooser control.
 *  The default value is <code>[ 0xE1E5EB, 0xF4F5F7 ]</code>.
 */
[Style(name="headerColors", type="Array", arrayType="uint", format="Color", inherit="yes")]

/**
 *  Name of the style sheet definition to configure the text (month name and year)
 *  and appearance of the header area of the control.
 */
[Style(name="mounthHeaderStyleName", type="String", inherit="no")]

[Style(name="yearhHeaderStyleName", type="String", inherit="no")]

/**
 *  Alpha transparencies used for the highlight fill of controls.
 *  The first value specifies the transparency of the top of the highlight and the second value specifies the transparency 
 *  of the bottom of the highlight. The highlight covers the top half of the skin.
 *  
 *  @default [ 0.3, 0.0 ]
 */
[Style(name="highlightAlphas", type="Array", arrayType="Number", inherit="no")]

/**
 *  Color of the highlight area of the date when the user holds the
 *  mouse pointer over a date in the DateChooser control.
 *  @default 0xE3FFD6
 */
[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  Name of the class to use as the skin for the 
 *  highlight area of the date when the user holds the
 *  mouse pointer over a date in the DateChooser control.
 *
 *  @default mx.skins.halo.DateChooserIndicator
 */
[Style(name="rollOverIndicatorSkin", type="Class", inherit="no")]

/**
 *  Color of the highlight area of the currently selected date
 *  in the DateChooser control.
 *  @default 0xCDFFC1
 */
[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  Name of the class to use as the skin for the 
 *  highlight area of the currently selected date
 *  in the DateChooser control.
 *
 *  @default mx.skins.halo.DateChooserIndicator
 */
[Style(name="selectionIndicatorSkin", type="Class", inherit="no")]

/**
 *  Color of the background of today's date.
 *  The default value is <code>0x818181</code>.
 */
[Style(name="todayColor", type="uint", format="Color", inherit="yes")]

/**
 *  Name of the class to use as the skin for the 
 *  highlight area of today's date
 *  in the DateChooser control.
 *
 *  @default mx.skins.halo.DateChooserIndicator
 */
[Style(name="todayIndicatorSkin", type="Class", inherit="no")]

/**
 *  Name of the style sheet definition to configure the appearance of the current day's
 *  numeric text, which is highlighted
 *  in the control when the <code>showToday</code> property is <code>true</code>.
 *  Specify a "color" style to change the font color.
 *  If omitted, the current day text inherits
 *  the text styles of the control.
 */
[Style(name="todayStyleName", type="String", inherit="no")]

/**
 *  Name of the style sheet definition to configure the weekday names of
 *  the control. If omitted, the weekday names inherit the text
 *  styles of the control.
 */
[Style(name="weekDayStyleName", type="String", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.DateChooserAccImpl")]

[DefaultBindingProperty(source="selectedDate", destination="selectedDate")]

[DefaultTriggerEvent("change")]

public class DateTimeChooser extends UIComponent implements IFocusManagerComponent, IFontContextComponent
{
    

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var HEADER_WIDTH_PAD:Number = 5;

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by DateChooserAccImpl.
     */
    mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function DateTimeChooser()
    {
        super();
		this.focusEnabled=true;
        tabEnabled = true;
        tabChildren = true;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     * 背景
     */
    mx_internal var background:UIComponent;
    
    /**
     *  @private
     * 边框
     */
    mx_internal var border:UIComponent;
    
    /**
     *  @private
     *  上边框
     */
    mx_internal var headerDisplay:UIComponent;
    
    /**
     *  @private
     * 显示月份 
     * 
     */
    mx_internal var monthDisplay:ComboBox;
    
    /**
     *  @private
     *  日历表头
     */
    mx_internal var calHeader:UIComponent;
    
    /**
     *  @private
     * 显示年份
     */
    mx_internal var yearDisplay:NumericStepper;
     
    /**
     *  @private
     *  日历主体主件
     */
    mx_internal var dateGrid:CalendarLayout;
	/**
     *  @private
     *  显示时间控件
     */
    mx_internal var time:TimeInputNumericStepper;
    /**
     *  @private
     *  阴影
     */
    mx_internal var dropShadow:RectangularDropShadow;

    /**
     *  @private
     */
    private var previousSelectedCellIndex:Number = NaN;

   
    /**
     *  @private
     *  日历头高度
     */
    private var headerHeight:Number = 30;
    
    
     /**
     *  @private
     * 时间控件宽
     */
    private var timeWidth:Number;
      /**
     *  @private
     * 时间控件高
     */
	private var timeHeight:Number;
    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the enabled property.
     *  是否禁用 
     */
    private var _enabled:Boolean = true;
    
    /**
     *  @private
     */
    private var enabledChanged:Boolean = false;

    [Bindable("enabledChanged")]
    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     */
    override public function get enabled():Boolean
    {
        return _enabled;
    }

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        if (value == _enabled)
            return;

        _enabled = value;
        super.enabled = value;
        enabledChanged = true;

        invalidateProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  allowDisjointSelection
    //----------------------------------

    /**
     *  @private
     *  Storage for the allowDisjointSelection property.
     */
    private var _allowDisjointSelection:Boolean = true;

    /**
     *  @private
     */
    private var allowDisjointSelectionChanged:Boolean = false;

    [Bindable("allowDisjointSelectionChanged")]
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  If <code>true</code>, specifies that non-contiguous(disjoint)
     *  selection is allowed in the DateChooser control.
     *  This property has an effect only if the
     *  <code>allowMultipleSelection</code> property is <code>true</code>.
     *  Setting this property changes the appearance of the
     *  DateChooser control.
     *
     *  @default true;
     *  @helpid
     *  @tiptext Non-contiguous is allowed if true
     */
    public function get allowDisjointSelection():Boolean
    {
        return _allowDisjointSelection;
    }

    /**
     *  @private
     */
    public function set allowDisjointSelection(value:Boolean):void
    {
        _allowDisjointSelection = value;
        allowDisjointSelectionChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  allowMultipleSelection
    //----------------------------------

    /**
     *  @private
     *  Storage for the allowMultipleSelection property.
     * 允许选择多个日期
     */
    private var _allowMultipleSelection:Boolean = false;

    /**
     *  @private
     */
    private var allowMultipleSelectionChanged:Boolean = false;

    [Bindable("allowMultipleSelectionChanged")]
    [Inspectable(category="General", defaultValue="false")]

    /**
     *  If <code>true</code>, specifies that multiple selection
     *  is allowed in the DateChooser control.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  @default false
     *  @helpid
     *  @tiptext Multiple selection is allowed if true
     */
    public function get allowMultipleSelection():Boolean
    {
        return _allowMultipleSelection;
    }

    /**
     *  @private
     */
    public function set allowMultipleSelection(value:Boolean):void
    {
        _allowMultipleSelection = value;
        allowMultipleSelectionChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  calendarLayoutStyleFilters
    //----------------------------------

    /**
     *  The set of styles to pass from the DateChooser to the calendar layout.
     *  @see mx.styles.StyleProxy
     */
    protected function get calendarLayoutStyleFilters():Object
    {
        return null;
    }
    
    //----------------------------------
    //  dayNames
    //----------------------------------

    /**
     *  @private
     *  Storage for the dayNames property.
     *  显示星期的数据源
     */
    private var _dayNames:Array=[ 'S', 'M', 'T', 'W', 'T', 'F', 'S' ];

    /**
     *  @private
     */
    private var dayNamesChanged:Boolean = false;

    /**
     *  @private
     */
    private var dayNamesOverride:Array;
    
    [Bindable("dayNamesChanged")]
    [Inspectable(arrayType="String", defaultValue="[ 'S', 'M', 'T', 'W', 'T', 'F', 'S' ]")]

    /**
     *  The weekday names for DateChooser control.
     *  Changing this property changes the day labels
     *  of the DateChooser control.
     *  Sunday is the first day (at index 0).
     *  The rest of the week names follow in the normal order.
     *
     *  @default [ "S", "M", "T", "W", "T", "F", "S" ].
     *  @helpid 3607
     *  @tiptext The names of days of week in a DateChooser
     */
    public function get dayNames():Array
    {
        return _dayNames;
    }

    /**
     *  @private
     */
    public function set dayNames(value:Array):void
    {
        dayNamesOverride = value;

        _dayNames = value != null ?
                    value :[ 'S', 'M', 'T', 'W', 'T', 'F', 'S' ];
        
        // _dayNames will be null if there are no resources.
        _dayNames = _dayNames ? _dayNames.slice(0) : null;

        dayNamesChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  disabledDays
    //----------------------------------

    /**
     *  @private
     *  Storage for the disabledDays property.
     *  日期不能选择的范围,是单个日期
     */
    private var _disabledDays:Array = [];

    /**
     *  @private
     */
    private var disabledDaysChanged:Boolean = false;

    [Bindable("disabledDaysChanged")]
    [Inspectable(arrayType="Date")]

    /**
     *  The days to disable in a week.
     *  All the dates in a month, for the specified day, are disabled.
     *  This property changes the appearance of the DateChooser control.
     *  The elements of this array can have values from 0 (Sunday) to
     *  6 (Saturday).
     *  For example, a value of <code>[ 0, 6 ]</code>
     *  disables Sunday and Saturday.
     *
     *  @default []
     *  @helpid 3608
     *  @tiptext The disabled days in a week
     */
    public function get disabledDays():Array
    {
        return _disabledDays;
    }

    /**
     *  @private
     */
    public function set disabledDays(value:Array):void
    {
        _disabledDays = value;
        disabledDaysChanged = true;
        invalidateProperties();
    }

    //----------------------------------
    //  disabledRanges
    //----------------------------------

    /**
     *  @private
     *  Storage for the disabledRanges property.
     * 存储不能选择的日期范围，连续日期
     * disabledRanges="{[ new Date(2006,0,11), {rangeStart:
     *  new Date(2006,0,23), rangeEnd: new Date(2006,1,10)},
     *  {rangeStart: new Date(2006,2,1)} ]}
     */
    private var _disabledRanges:Array = [];

    /**
     *  @private
     */
    private var disabledRangesChanged:Boolean = false;

    [Bindable("disabledRangesChanged")]
    [Inspectable(arrayType="Object")]

    /**
     *  Disables single and multiple days.
     *
     *  <p>This property accepts an Array of objects as a parameter.
     *  Each object in this array is a Date object, specifying a
     *  single day to disable; or an object containing either or both
     *  of the <code>rangeStart</code> and <code>rangeEnd</code> properties,
     *  each of whose values is a Date object.
     *  The value of these properties describes the boundaries
     *  of the date range.
     *  If either is omitted, the range is considered
     *  unbounded in that direction.
     *  If you specify only <code>rangeStart</code>,
     *  all the dates after the specified date are disabled,
     *  including the <code>rangeStart</code> date.
     *  If you specify only <code>rangeEnd</code>,
     *  all the dates before the specified date are disabled,
     *  including the <code>rangeEnd</code> date.
     *  To disable a single day, use a single Date object specifying a date
     *  in the Array. Time values are zeroed out from the Date 
     *  object if they are present.</p>
     *
     *  <p>The following example, disables the following dates: January 11
     *  2006, the range January 23 - February 10 2006, and March 1 2006
     *  and all following dates.</p>
     *
     *  <p><code>disabledRanges="{[ new Date(2006,0,11), {rangeStart:
     *  new Date(2006,0,23), rangeEnd: new Date(2006,1,10)},
     *  {rangeStart: new Date(2006,2,1)} ]}"</code></p>
     *
     *  @default []
     *  @helpid 3610
     *  @tiptext The disabled dates inside the selectableRange
     */
    public function get disabledRanges():Array
    {
        return _disabledRanges;
    }

    /**
     *  @private
     */
    public function set disabledRanges(value:Array):void
    {
        _disabledRanges = scrubTimeValues(value);
        disabledRangesChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  displayedMonth
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayedMonth property.
     *   显示的月份 默认是当月
     */
    private var _displayedMonth:int = (new Date()).getMonth();

    /**
     *  @private
     */
    private var displayedMonthChanged:Boolean = false;

    [Bindable("viewChanged")]
    [Inspectable(category="General")]

    /**
     *  Used together with the <code>displayedYear</code> property,
     *  the <code>displayedMonth</code> property specifies the month
     *  displayed in the DateChooser control.
     *  Month numbers are zero-based, so January is 0 and December is 11.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  <p>The default value is the current month.</p>
     *
     *  @helpid 3605
     *  @tiptext The currently displayed month in the DateChooser
     */
    public function get displayedMonth():int
    {
        if (dateGrid && _displayedMonth != dateGrid.displayedMonth)
            return dateGrid.displayedMonth;
        else
            return _displayedMonth;
    }

    /**
     *  @private
     */
    public function set displayedMonth(value:int):void
    {
        if (isNaN(value) || displayedMonth == value)
            return;
        
        _displayedMonth = value;
        displayedMonthChanged = true;
        
        invalidateProperties();
        
        if (dateGrid)
            dateGrid.displayedMonth = value; // if it's already this value shouldn't do anything
    }

    //----------------------------------
    //  displayedYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayedYear property.
     * 显示的年份 默认是当年
     */
    private var _displayedYear:int = (new Date()).getFullYear();

    /**
     *  @private
     */
    private var displayedYearChanged:Boolean = false;

    [Bindable("viewChanged")]
    [Inspectable(category="General")]

    /**
     *  Used together with the <code>displayedMonth</code> property,
     *  the <code>displayedYear</code> property specifies the month
     *  displayed in the DateChooser control.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  <p>The default value is the current year.</p>
     *
     *  @helpid 3606
     *  @tiptext The currently displayed year in DateChooser
     */
    public function get displayedYear():int
    {
        if (dateGrid)
            return dateGrid.displayedYear;
        else
            return _displayedYear;
    }

    /**
     *  @private
     */
    public function set displayedYear(value:int):void
    {
        if (isNaN(value) || displayedYear == value)
            return;
        
        _displayedYear = value;
        displayedYearChanged = true;
        
        invalidateProperties();
        
        if (dateGrid)
            dateGrid.displayedYear = value;// if it's already this value shouldn't do anything
    }

    //----------------------------------
    //  firstDayOfWeek
    //----------------------------------

    /**
     *  @private
     *  Storage for the firstDayOfWeek property.
     *  显示日期的顺序 就是每周第一天的显示是周几
     */
    private var _firstDayOfWeek:Object;

    /**
     *  @private
     */
    private var firstDayOfWeekChanged:Boolean = false;

    /**
     *  @private
     */
    private var firstDayOfWeekOverride:Object;
    
    [Bindable("firstDayOfWeekChanged")]
    [Inspectable(defaultValue="null")]

    /**
     *  Number representing the day of the week to display in the
     *  first column of the DateChooser control.
     *  The value must be in the range 0 to 6, where 0 corresponds to Sunday,
     *  the first element of the <code>dayNames</code> Array.
     *
     *  <p>Setting this property changes the order of the day columns.
     *  For example, setting it to 1 makes Monday the first column
     *  in the control.</p>
     *
     *  @default 0 (Sunday)
     *  @tiptext Sets the first day of week for DateChooser
     */
    public function get firstDayOfWeek():Object
    {
        return _firstDayOfWeek;
    }

    /**
     *  @private
     */
    public function set firstDayOfWeek(value:Object):void
    {
        firstDayOfWeekOverride = value;
        
        _firstDayOfWeek = value != null ?
                          int(value) :0;
        
        
        firstDayOfWeekChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  fontContext
    //----------------------------------
    
    /**
     *  @private
     *  
     */
    public function get fontContext():IFlexModuleFactory
    {
        return moduleFactory;
    }

    /**
     *  @private
     */
    public function set fontContext(moduleFactory:IFlexModuleFactory):void
    {
        this.moduleFactory = moduleFactory;
    }
    
    //----------------------------------
    //  maxYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxYear property.
     *  最大年份
     */
    private var _maxYear:int = 2100;

    /**
     *  The last year selectable in the control.
     *
     *  @default 2100
     *  @helpid
     *  @tiptext Maximum year limit
     */
    public function get maxYear():int
    {
        return _maxYear;
    }

    /**
     *  @private
     */
    public function set maxYear(value:int):void
    {
        if (_maxYear == value)
            return;

        _maxYear = value;
    }

    //----------------------------------
    //  minYear
    //----------------------------------

    /**
     *  @private
     *  Storage for the minYear property.
     * 最小年份
     */
    private var _minYear:int = 1900;

    /**
     *  The first year selectable in the control.
     *
     *  @default 1900
     *  @helpid
     *  @tiptext Minimum year limit
     */
    public function get minYear():int
    {
        return _minYear;
    }

    /**
     *  @private
     */
    public function set minYear(value:int):void
    {
        if (_minYear == value)
            return;

        _minYear = value;
    }

    //----------------------------------
    //  monthNames
    //----------------------------------

    /**
     *  @private
     *  Storage for the monthNames property.
     * 月份显示 语言
     */
    private var _monthNames:Array=[ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
    
    /**
     *  @private
     */
    private var monthNamesChanged:Boolean = false;

    /**
     *  @private
     */
    private var monthNamesOverride:Array;
    
    [Bindable("monthNamesChanged")]
    [Inspectable(arrayType="String", defaultValue="[ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' ]")]

    /**
     *  Names of the months displayed at the top of the DateChooser control.
     *  The <code>monthSymbol</code> property is appended to the end of 
     *  the value specified by the <code>monthNames</code> property, 
     *  which is useful in languages such as Japanese.
     *
     *  @default [ "January", "February", "March", "April", "May", "June", 
     *  "July", "August", "September", "October", "November", "December" ]
     *  @tiptext The name of the months displayed in the DateChooser
     */
    public function get monthNames():Array
    {
        return _monthNames;
    }

    /**
     *  @private
     */
    public function set monthNames(value:Array):void
    {
        monthNamesOverride = value;

        _monthNames = value != null ?
                      value :[ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]; 
        // _monthNames will be null if there are no resources.
        _monthNames = _monthNames ? monthNames.slice(0) : null;

        monthNamesChanged = true;

        invalidateProperties();
        invalidateSize();
    }

    //----------------------------------
    //  monthSymbol
    //----------------------------------

    /**
     *  @private
     *  Storage for the monthSymbol property.
     */
    private var _monthSymbol:String;

    /**
     *  @private
     */
    private var monthSymbolChanged:Boolean = false;

    /**
     *  @private
     */
    private var monthSymbolOverride:String;
    
    [Bindable("monthSymbolChanged")]
    [Inspectable(defaultValue="")]

    /**
     *  This property is appended to the end of the value specified 
     *  by the <code>monthNames</code> property to define the names 
     *  of the months displayed at the top of the DateChooser control.
     *  Some languages, such as Japanese, use an extra 
     *  symbol after the month name. 
     *
     *  @default ""
     */
    public function get monthSymbol():String
    {
        return _monthSymbol;
    }

    /**
     *  @private
     */
    public function set monthSymbol(value:String):void
    {
        monthSymbolOverride = value;

        _monthSymbol = value != null ?
                       value :"";
        monthSymbolChanged = true;

        invalidateProperties();
    }
    
    

    //----------------------------------
    //  selectableRange
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectableRange property.
     *  可以选取的范围
     */
    private var _selectableRange:Object;

    /**
     *  @private
     */
    private var selectableRangeChanged:Boolean = false;

    [Bindable("selectableRangeChanged")]

    /**
     *  Range of dates between which dates are selectable.
     *  For example, a date between 04-12-2006 and 04-12-2007
     *  is selectable, but dates out of this range are disabled.
     *
     *  <p>This property accepts an Object as a parameter.
     *  The Object contains two properties, <code>rangeStart</code>
     *  and <code>rangeEnd</code>, of type Date.
     *  If you specify only <code>rangeStart</code>,
     *  all the dates after the specified date are enabled.
     *  If you only specify <code>rangeEnd</code>,
     *  all the dates before the specified date are enabled.
     *  To enable only a single day in a DateChooser control,
     *  you can pass a Date object directly. Time values are 
     *  zeroed out from the Date object if they are present.</p>
     *
     *  <p>The following example enables only the range
     *  January 1, 2006 through June 30, 2006. Months before January
     *  and after June do not appear in the DateChooser.</p>
     *
     *  <p><code>selectableRange="{{rangeStart : new Date(2006,0,1),
     *  rangeEnd : new Date(2006,5,30)}}"</code></p>
     *
     *  @default null
     *  @helpid 3609
     *  @tiptext The start and end dates between which a date can be selected
     */
    public function get selectableRange():Object
    {
        return _selectableRange;
    }

    /**
     *  @private
     */
    public function set selectableRange(value:Object):void
    {
        _selectableRange = scrubTimeValue(value);
        selectableRangeChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  selectedDate
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedDate property.
     *  选取的日期
     */
    private var _selectedDate:Date;

    /**
     *  @private
     */
    private var selectedDateChanged:Boolean = false;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]

    /**
     *  Date selected in the DateChooser control.
     *  If the incoming Date object has any time values, 
     *  they are zeroed out.
     *
     *  <p>Holding down the Control key when selecting the 
     *  currently selected date in the control deselects it, 
     *  sets the <code>selectedDate</code> property to <code>null</code>, 
     *  and then dispatches the <code>change</code> event.</p>
     *
     *  @default null
     */
    public function get selectedDate():Date
    {
        return _selectedDate;
    }

    /**
     *  @private
     */
    public function set selectedDate(value:Date):void
    {
        _selectedDate = scrubTimeValue(value) as Date;
        selectedDateChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  selectedRanges
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedRanges property.
     */
    private var _selectedRanges:Array = [];

    /**
     *  @private
     */
    private var selectedRangesChanged:Boolean = false;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(arrayType="Date")]

    /**
     *  Selected date ranges.
     *
     *  <p>This property accepts an Array of objects as a parameter.
     *  Each object in this array has two date Objects,
     *  <code>rangeStart</code> and <code>rangeEnd</code>.
     *  The range of dates between each set of <code>rangeStart</code>
     *  and <code>rangeEnd</code> (inclusive) are selected.
     *  To select a single day, set both <code>rangeStart</code> and <code>rangeEnd</code>
     *  to the same date. Time values are zeroed out from the Date 
     *  object if they are present.</p>
     * 
     *  <p>The following example, selects the following dates: January 11
     *  2006, the range January 23 - February 10 2006. </p>
     *
     *  <p><code>selectedRanges="{[ {rangeStart: new Date(2006,0,11),
     *  rangeEnd: new Date(2006,0,11)}, {rangeStart:new Date(2006,0,23),
     *  rangeEnd: new Date(2006,1,10)} ]}"</code></p>
     *
     *  @default []
     *  @helpid 0000
     *  @tiptext The selected dates
     */
    public function get selectedRanges():Array
    {
        _selectedRanges = dateGrid.selectedRanges;
        return _selectedRanges;
    }

    /**
     *  @private
     */
    public function set selectedRanges(value:Array):void
    {
        _selectedRanges = scrubTimeValues(value);
        selectedRangesChanged = true;

        invalidateProperties();
    }

    //----------------------------------
    //  showToday
    //----------------------------------

    /**
     *  @private
     *  Storage for the showToday property.
     */
    private var _showToday:Boolean = true;

    /**
     *  @private
     */
    private var showTodayChanged:Boolean = false;

    [Bindable("showTodayChanged")]
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  If <code>true</code>, specifies that today is highlighted
     *  in the DateChooser control.
     *  Setting this property changes the appearance of the DateChooser control.
     *
     *  @default true
     *  @helpid 3603
     *  @tiptext The highlight on the current day of the month
     */
    public function get showToday():Boolean
    {
        return _showToday;
    }

    /**
     *  @private
     */
    public function set showToday(value:Boolean):void
    {
        _showToday = value;
        showTodayChanged = true;

        invalidateProperties();
    }

	//----------------------------------
    //  TimeEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the _timeEnabled property.
     *  是否显示时间控件
     */
    private var _timeEnabled:Boolean = true;

    /**
     *  @private
     */
    private var timeEnabledChanged:Boolean = false;

    [Bindable("timeEnabledChanged")]
    [Inspectable(defaultValue="true")]

    /**
     *  Enables TimeEnabled. When <code>true</code>
     *  a timeCom appear to the Bottom
     *  of the displayed time. You can use these buttons
     *  to change the current time.
     *
     *  @default true
     *  @tiptext Enables Time
     */
    public function get timeEnabled():Boolean
    {
        return _timeEnabled;
    }

    /**
     *  @private
     */
    public function set timeEnabled(value:Boolean):void
    {
        _timeEnabled = value;
        timeEnabledChanged = true;

        invalidateProperties();
    }
	
	
    //----------------------------------
    //  yearSymbol
    //----------------------------------

    /**
     *  @private
     *  Storage for the yearSymbol property.
     */
    private var _yearSymbol:String;

    /**
     *  @private
     */
    private var yearSymbolChanged:Boolean = false;

    /**
     *  @private
     */
    private var yearSymbolOverride:String;
    
    [Bindable("yearSymbolChanged")]
    [Inspectable(defaultValue="")]

    /**
     *  This property is appended to the end of the year 
     *  displayed at the top of the DateChooser control.
     *  Some languages, such as Japanese, 
     *  add a symbol after the year. 
     *
     *  @default ""
     */
    public function get yearSymbol():String
    {
        return _yearSymbol;
    }

    /**
     *  @private
     */
    public function set yearSymbol(value:String):void
    {
        yearSymbolOverride = value;

        _yearSymbol = value != null ?
                      value :"";
                    

        yearSymbolChanged = true;

        invalidateProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function initializeAccessibility():void
    {
        if (DateTimeChooser.createAccessibilityImplementation != null)
            DateTimeChooser.createAccessibilityImplementation(this);
    }

    /**
     *  @private
     *  Create subobjects in the component. 
     *   header row, background and border.
     */
    override protected function createChildren():void
    {
        super.createChildren();

        if (!background)
        {
            background = new UIComponent();
            addChild(background);
            UIComponent(background).styleName = this;
        }

        if (!border)
        {
            border = new UIComponent();
            addChild(border);
            UIComponent(border).styleName = this;
        }

        // Create the dateGrid.
        // This must be created before calling updateDateDisplay().
        if (!dateGrid)
        {
            dateGrid = new CalendarLayout();
            dateGrid.styleName = new StyleProxy(this, calendarLayoutStyleFilters); // TODO Do we need a StyleProxy for this?
            addChild(dateGrid);
            dateGrid.addEventListener(CalendarLayoutChangeEvent.CHANGE,
                                      dateGrid_changeHandler);
            dateGrid.addEventListener(DateChooserEvent.SCROLL,
                                      dateGrid_scrollHandler);
        }

        if (!calHeader)
        {
            calHeader = new UIComponent();
            addChild(calHeader);
            UIComponent(calHeader).styleName = this;
        }
        if(_timeEnabled)
        {
        	createTimeDisplay();
        }

        createMonthDisplay();
        createYearDisplay();
        
      
    }  


	
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        
        if (showTodayChanged)
        {
            showTodayChanged = false;
            dateGrid.showToday = _showToday;
            dispatchEvent(new Event("showTodayChanged"));
        }

        if (enabledChanged)
        {
            enabledChanged = false;
            monthDisplay.enabled = _enabled;
            yearDisplay.enabled = _enabled;
            dateGrid.enabled = _enabled;
            time.enabled=_enabled;
            dispatchEvent(new Event("enabledChanged"));
        }

        if (firstDayOfWeekChanged)
        {
            firstDayOfWeekChanged = false;
            dateGrid.firstDayOfWeek = int(_firstDayOfWeek);
            dispatchEvent(new Event("firstDayOfWeekChanged"));
        }

        if (displayedMonthChanged)
        {
            displayedMonthChanged = false;
            dateGrid.displayedMonth = _displayedMonth;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
        }

        if (displayedYearChanged)
        {
            displayedYearChanged = false;
            dateGrid.displayedYear = _displayedYear;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
        }

        if (dayNamesChanged)
        {
            dayNamesChanged = false;
            // _dayNames will be null if there are no resources.
            dateGrid.dayNames = _dayNames ? _dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
        }

        if (disabledDaysChanged)
        {
            disabledDaysChanged = false;
            dateGrid.disabledDays = _disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
        }

        if (selectableRangeChanged)
        {
            selectableRangeChanged = false;
            dateGrid.selectableRange = _selectableRange is Array ? _selectableRange.slice(0) : _selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
            invalidateDisplayList();
        }

        if (disabledRangesChanged)
        {
            disabledRangesChanged = false;
            dateGrid.disabledRanges = _disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
        }

        if (selectedDateChanged)
        {
            selectedDateChanged = false;
            dateGrid.selectedDate = _selectedDate;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }

        if (selectedRangesChanged)
        {
            selectedRangesChanged = false;
            dateGrid.selectedRanges = _selectedRanges;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
        }

        if (allowMultipleSelectionChanged)
        {
            allowMultipleSelectionChanged = false;
            dateGrid.allowMultipleSelection = _allowMultipleSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowMultipleSelectionChanged"));
        }

        if (allowDisjointSelectionChanged)
        {
            allowDisjointSelectionChanged = false;
            dateGrid.allowDisjointSelection = _allowDisjointSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowDisjointSelectionChanged"));
        }
		
        if (monthNamesChanged)
        {
            monthNamesChanged = false;
            invalidateDisplayList();
            dispatchEvent(new Event("monthNamesChanged"));
        }

        
        if(timeEnabledChanged)
        {
        	 if (_timeEnabled)
            {
                createTimeDisplay();
            }
            else if (time)
            {
                removeChild(time);
                time = null;
               
            }
            timeEnabledChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("timeEnabledChanged"));
        }
        
        
        
        
        
        if (yearSymbolChanged)
        {
            yearSymbolChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearSymbolChanged"));
        }
        
        if (monthSymbolChanged)
        {
            monthSymbolChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("monthSymbolChanged"));
        }       
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

       updateDateDisplay();
        //setMonthWidth();

        var borderThickness:Number = getStyle("borderThickness");
		
        // Wait until the initial style values have been set on this element,
        // and then pass those initial values down to my children
       // monthSkinWidth =monthDisplay.getExplicitOrMeasuredWidth();
       // monthSkinHeight = monthDisplay.getExplicitOrMeasuredHeight();
       
        if(_timeEnabled)
        {
        	timeWidth=time.getExplicitOrMeasuredWidth();
        	timeHeight=time.getExplicitOrMeasuredHeight();
        }
        else
        {
        	timeWidth=0;
        	timeHeight=0;
        }
        headerHeight = Math.max(monthDisplay.getExplicitOrMeasuredHeight(),yearDisplay.getExplicitOrMeasuredHeight());
        measuredWidth = Math.max(dateGrid.getExplicitOrMeasuredWidth()
            + borderThickness*2,
            monthDisplay.getExplicitOrMeasuredWidth() + yearDisplay.getExplicitOrMeasuredWidth() +
            HEADER_WIDTH_PAD +borderThickness*2 ,timeWidth+borderThickness*2);
        measuredHeight = timeHeight+headerHeight + dateGrid.getExplicitOrMeasuredHeight() + borderThickness * 2;
        measuredMinWidth = dateGrid.minWidth;
        measuredMinHeight = dateGrid.minHeight + headerHeight+timeHeight;
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

       updateDateDisplay();

        var borderThickness:Number = getStyle("borderThickness");
        var cornerRadius:Number = getStyle("cornerRadius");
        var borderColor:Number = getStyle("borderColor");

        var w:Number = unscaledWidth - borderThickness*2;
        var h:Number = unscaledHeight - borderThickness*2;

        // Wait until the initial style values have been set on this element,
        // and then pass those initial values down to my children
        var monthHeight:Number = monthDisplay.getExplicitOrMeasuredHeight();
        var monthWidth:Number = monthDisplay.getExplicitOrMeasuredWidth();
        var yearWidth:Number = yearDisplay.getExplicitOrMeasuredWidth();
        var dateFormat:String = "YYYY-MM-DD";
        
        var swapOrder:Boolean = yearBeforeMonth(dateFormat);//年 月的顺序 初始化为true
       var yearX:Number;
        if (swapOrder)
            yearX = borderThickness + monthWidth + HEADER_WIDTH_PAD;//
        else
            yearX =borderThickness;//
        var dateHeight:Number = borderThickness + (headerHeight - monthHeight) / 2;

       // var allPads:Number = HEADER_WIDTH_PAD;//月
        monthDisplay.setActualSize(Math.max(monthWidth, 0), monthHeight);
        if (swapOrder)
            monthDisplay.move(borderThickness+yearWidth+HEADER_WIDTH_PAD, dateHeight);//月份在右
        else
            monthDisplay.move(borderThickness, dateHeight);//月份在左
        monthDisplay.visible = true;
       //年
        yearDisplay.setActualSize(Math.max(yearWidth , 0), monthHeight);
        if (swapOrder)//年在左
            yearDisplay.move(borderThickness, dateHeight);
        else
            yearDisplay.move(yearX, dateHeight);//把年移动到右
        yearDisplay.visible = true;
        //日历主体		
        dateGrid.setActualSize(w, h - headerHeight-timeHeight);
        dateGrid.move(borderThickness, headerHeight + borderThickness);//把日历移动到位置
		//时间
		if(_timeEnabled)
		{
			time.setActualSize(w-4,timeHeight);
	        time.move(borderThickness+2, headerHeight+borderThickness+dateGrid.height-1);//把时间移动到位置
		}
       
       //日历背景 w，h
        var g:Graphics = background.graphics;
        g.clear();
        g.beginFill(0xFFFFFF);
        g.drawRoundRect(0, 0, w, h, cornerRadius * 2, cornerRadius * 2);
        g.endFill();
        background.$visible = true;
		//边框
        g = border.graphics;
        g.clear();
        g.beginFill(borderColor);
        g.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 
                        cornerRadius * 2, cornerRadius * 2);
        g.endFill();
        //背景
        var bgColor:uint = StyleManager.NOT_A_COLOR;
        bgColor = getStyle("backgroundColor");
        if (bgColor == 0)
            bgColor = 0xffffff;//默认背景
        var bgAlpha:Number = 1;
        bgAlpha = getStyle("backgroundAlpha");
        g.beginFill(bgColor, bgAlpha);
        g.drawRoundRect(borderThickness, borderThickness, w, h, 
                        cornerRadius > 0 ? (cornerRadius - 1) * 2 : 0,
                        cornerRadius > 0 ? (cornerRadius - 1) * 2 : 0);
        g.endFill();
        border.visible = true;
        
		//日历头
		if(getStyle("headerColors")!=null)
        var headerColors:Array = getStyle("headerColors");
        else
        	headerColors=[ 0xE1E5EB, 0xF4F5F7 ];//默认
        StyleManager.getColorNames(headerColors);
        var calHG:Graphics = calHeader.graphics;
        calHG.clear();
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(w, headerHeight, Math.PI / 2, 0, 0);
        calHG.beginGradientFill(GradientType.LINEAR,
                                headerColors,
                                [1.0,1.0],
                                [ 0, 0xFF ],
                                matrix);
        GraphicsUtil.drawRoundRectComplex(calHG, borderThickness, borderThickness,
            w, headerHeight, cornerRadius, cornerRadius, 0, 0);
        calHG.endFill();
        calHG.lineStyle(borderThickness, borderColor);
        calHG.moveTo(borderThickness, headerHeight + borderThickness);
        calHG.lineTo(w + borderThickness, headerHeight + borderThickness);
        calHeader.$visible = true;

		//阴影
        var dsStyle:Object = getStyle("dropShadowEnabled");
        graphics.clear();
        if (dsStyle == true || (dsStyle is String && String(dsStyle).toLowerCase() == "true"))
        {
            // Calculate the angle and distance for the shadow
            var distance:Number = getStyle("shadowDistance");
            var direction:String = getStyle("shadowDirection");
            var angle:Number;
            angle = 90; // getDropShadowAngle(distance, direction);
            distance = Math.abs(distance) + 2;

            // Create a RectangularDropShadow object, set its properties, and
            // draw the shadow
            if (!dropShadow)
                dropShadow = new RectangularDropShadow();

            dropShadow.distance = distance;
            dropShadow.angle = angle;
            dropShadow.color = getStyle("dropShadowColor");
            dropShadow.alpha = 0.4;

            dropShadow.tlRadius = cornerRadius;
            dropShadow.trRadius = cornerRadius;
            dropShadow.blRadius = cornerRadius;
            dropShadow.brRadius = cornerRadius;

            dropShadow.drawShadow(graphics, borderThickness, borderThickness, w, h);
        }
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        if (styleProp == null || styleProp == "styleName" ||
            styleProp == "borderColor" || styleProp == "headerColor" ||
            styleProp == "headerColors" || styleProp == "backgroundColor" ||
            styleProp =="horizontalGap" || styleProp == "verticalGap" ||
            styleProp =="backgroundAlpha")
        {       
            invalidateDisplayList();
        }

        if (styleProp == null || styleProp == "styleName" ||
            styleProp == "mounthHeaderStyleName"||styleProp == "yearHeaderStyleName"
             && monthDisplay&&yearDisplay)
        {
            var mounthHeaderStyleName:Object = getStyle("mounthHeaderStyleName");
             var yearHeaderStyleName:Object = getStyle("yearHeaderStyleName");
           
            if (!mounthHeaderStyleName)
                mounthHeaderStyleName = this;
            if(!yearHeaderStyleName)   
           		yearHeaderStyleName=this;
            if (monthDisplay)
                monthDisplay.styleName = mounthHeaderStyleName;
            if (yearDisplay)
                yearDisplay.styleName = yearHeaderStyleName;
        }

    }

    /**
     *  @private
     */
    override protected function resourcesChanged():void
    {
        super.resourcesChanged();

        dayNames = dayNamesOverride;
        firstDayOfWeek = firstDayOfWeekOverride;
        monthNames = monthNamesOverride;
        monthSymbol = monthSymbolOverride;
        yearSymbol = yearSymbolOverride;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
	 /**
     *  @private
     *  Creates the time display 
     *  and adds it as a child of this component.
     * 
     */
    mx_internal function createTimeDisplay():void
    {
        if (!time)
        {
            time = new TimeInputNumericStepper();  
           	time.focusEnabled=true;
            time.tabChildren=true;
            time.tabEnabled=true;  
            time.Time = this.selectedDate;
            time.setStyle("cornerRadius",0);  
            addChild(time);
        }

    }
    /**
     *  @private
     *  Creates the month display label
     *  and adds it as a child of this component.
     * 
     *  @param childIndex The index of where to add the child.
     *  If -1, the text field is appended to the end of the list.
     */
    mx_internal function createMonthDisplay():void
    {
        if (!monthDisplay)
        {
            monthDisplay = new ComboBox();
            monthDisplay.setStyle("cornerRadius",0);
           // monthDisplay.height=20;
           //	monthDisplay.width=100;
            monthDisplay.dataProvider=monthNames;          
          	monthDisplay.selectedIndex=dateGrid.displayedMonth;
          	monthDisplay.addEventListener(DropdownEvent.CLOSE,MonthCombobox_DownHandler);
            addChild(DisplayObject(monthDisplay));          
            var mounthHeaderStyleName:Object = getStyle("mounthHeaderStyleName");
            if (!mounthHeaderStyleName)
                mounthHeaderStyleName = this;
             monthDisplay.styleName= mounthHeaderStyleName;
        }

    }
	/**
	 *月份改变时dateGrid同时改变
	 * @private
	 */
	 private function MonthCombobox_DownHandler(event:Event):void
    {
    	displayedMonth = ComboBox(event.target).selectedIndex;
        if ((maxYear < displayedYear + 1) && (displayedMonth == 11))
            return;

        if ((selectableRange) &&
            (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 3))
	        {
	            var testDate:Date = new Date(displayedYear, displayedMonth,
	                                         selectableRange.rangeEnd.getDate());
	
	            if (selectableRange.rangeEnd > testDate)
	            {
	                dateGrid.displayedMonth=event.target.selectedIndex;
	                invalidateDisplayList();
	            }
	
	        }
        else if (dateGrid.selRangeMode != 4 || !selectableRange)
        {
            dateGrid.displayedMonth=event.target.selectedIndex;
            invalidateDisplayList();
        }
    }
    /**
     *  @private
     *  Removes the month dislay label from this component.
     */
    mx_internal function removeMonthDisplay():void
    {
        if (monthDisplay)
        {
            removeChild(DisplayObject(monthDisplay));
            monthDisplay = null;
        }
    }

    /**
     *  @private
     *  Creates the month display label and adds it as a child of this component.
     * 
     *  @param childIndex The index of where to add the child.
     *  If -1, the text field is appended to the end of the list.
     */
    mx_internal function createYearDisplay():void
    {
        if (!yearDisplay)
        {
            yearDisplay = new NumericStepper();
            yearDisplay.setStyle("cornerRadius",0);
            yearDisplay.maximum=maxYear;
            yearDisplay.minimum=minYear;
           yearDisplay.addEventListener(FlexEvent.CREATION_COMPLETE,listren)
            yearDisplay.addEventListener(NumericStepperEvent.CHANGE,NumChangeHandler);
            addChild(yearDisplay);
            var yearHeaderStyleName:Object = getStyle("yearHeaderStyleName");
            if (!yearHeaderStyleName)
                yearHeaderStyleName = this;
            yearDisplay.styleName = yearHeaderStyleName;
        }
    }
     private function listren(e:FlexEvent):void
     {
     	    yearDisplay.prevButton.addEventListener(FlexEvent.BUTTON_DOWN,
                                            downYearButton_buttonDownHandler);
            yearDisplay.nextButton.addEventListener(FlexEvent.BUTTON_DOWN,
                                            upYearButton_buttonDownHandler);
     }
	
	private function NumChangeHandler(event:Event):void
	{
		 if(event.target.value==event.target.maximum+1)
			{
				event.target.value=event.target.minimum;
			}
		else if(event.target.value==event.target.minimum-1)
			{
				event.target.value=event.target.maximum;
			} 
			
	    
	}
    /**
     *  @private
     *  Removes the month dislay label from this component.
     */
    mx_internal function removeYearDisplay():void
    {
        if (yearDisplay)
        {
            removeChild(DisplayObject(yearDisplay));
            yearDisplay = null;
        }
    }

    /**
     *  @private
     */
    mx_internal function updateDateDisplay():void
    {
        // monthNames will be null if there are no resources.
        var monthName:String = monthNames ?
                               monthNames[dateGrid.displayedMonth] :
                               ""; 
                           
        monthDisplay.text = monthName;
        yearDisplay.value = displayedYear;
    }


	 

    /**
     *  @private
     *  Returns true if year comes before month in DateFormat.
     *  Used for correct placement of year and month in header.
     */ 
    private function yearBeforeMonth(dateFormat:String):Boolean
    {
        // dateFormat will be null if there are no resources.
        var n:int = dateFormat != null ? dateFormat.length : 0;
        for (var i:int = 0; i < n; i++)
        {
            if (dateFormat.charAt(i) == "M")
                return false;
            else if (dateFormat.charAt(i) == "Y")
                return true;
        }
        return false;
    }
    
    /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
     mx_internal function scrubTimeValue(value:Object):Object
     {
        if (value is Date)
        {
            return new Date(value.getFullYear(), value.getMonth(), value.getDate(),value.getHours(),value.getMinutes(),value.getSeconds());
        }
        else if (value is Object) 
        {
            var range:Object = {};
            if (value.rangeStart)
            {
                range.rangeStart = new Date(value.rangeStart.getFullYear(), 
                                            value.rangeStart.getMonth(), 
                                            value.rangeStart.getDate());
            }
            
            if (value.rangeEnd)
            {
                range.rangeEnd = new Date(value.rangeEnd.getFullYear(), 
                                          value.rangeEnd.getMonth(), 
                                          value.rangeEnd.getDate());
            }
            return range;
        }
        return null;
     }
     
     /**
     *  @private
     *  This method scrubs out time values from incoming date objects
     */ 
     mx_internal function scrubTimeValues(values:Array):Array
     {
         var dates:Array = [];
         for (var i:int = 0; i < values.length; i++)
         {
            dates[i] = scrubTimeValue(values[i]);
         }
         return dates;
     }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    
    /**
     *  @private
     *  event is either a KeyboardEvent or a FlexEvent
     */
    private function upYearButton_buttonDownHandler(event:Event):void
    {
    	displayedYear = int(yearDisplay.value.toString());
        if (maxYear < displayedYear + 1)
            return;

        if ((selectableRange) &&
            (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 3))
        {
            var testDate:Date = new Date(displayedYear, displayedMonth,
                                         selectableRange.rangeEnd.getDate());

            if (selectableRange.rangeEnd > testDate)
            {
                dateGrid.stepDate(1, 0, event);
                invalidateDisplayList();
            }

        }
        else if (dateGrid.selRangeMode != 4 || !selectableRange)
        {
            dateGrid.stepDate(1, 0, event);
            invalidateDisplayList();
        }
    }

    /**
     *  @private
     *  event is either a KeyboardEvent or a FlexEvent
     */
    private function downYearButton_buttonDownHandler(event:Event):void
    {
    	displayedYear = int(yearDisplay.value.toString());
        if (minYear > displayedYear - 1)
            return;

        if (selectableRange &&
            (dateGrid.selRangeMode == 1 || dateGrid.selRangeMode == 2))
        {
            var testDate:Date = new Date(displayedYear, displayedMonth,
                                         selectableRange.rangeStart.getDate());

            if (selectableRange.rangeStart < testDate)
            {
                dateGrid.stepDate(-1, 0, event);
                invalidateDisplayList();
            }

        }
        else if (dateGrid.selRangeMode != 4 || !selectableRange)
        {
            dateGrid.stepDate(-1, 0, event);
            invalidateDisplayList();
        }
    }

    /**
     *  @private
     */
    private function dateGrid_scrollHandler(event:DateChooserEvent):void
    {
        dispatchEvent(event);
    }

    /**
     *  @private
     */
    private function dateGrid_changeHandler(event:CalendarLayoutChangeEvent):void
    {
        _selectedDate = CalendarLayout(event.target).selectedDate;
        
        var e:CalendarLayoutChangeEvent = new 
            CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
        e.newDate = event.newDate;
        e.triggerEvent = event.triggerEvent;
        dispatchEvent(e);
    }
  }
}


