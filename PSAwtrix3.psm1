
$Script:ModulePath = $PSScriptRoot

$Script:ModuleItem = Get-Item -Path $PSCommandPath

Add-Type -Assembly System.Drawing

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\$AwtrixAlias.ps1

$Script:AwtrixAlias = $null

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\$AwtrixAlias.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\Get-AwtrixAlias.ps1

function Get-AwtrixAlias
{
    [CmdletBinding()]
    param(
    )

    $Script:AwtrixAlias
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\Get-AwtrixAlias.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\Register-AwtrixAlias.ps1

function Register-AwtrixAlias
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][object]$InputObject,
        [Parameter()]                                                 [switch]$Global
    )

    Begin {
    }
    
    Process {

        if($InputObject -is [System.Collections.IDictionary])
        {
            $Script:AwtrixAlias = $InputObject

            if($Global)
            {
                Set-AwtrixGlobal -Device $InputObject.Keys
            }
        }
    }

    End {
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\Register-AwtrixAlias.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\Resolve-AwtrixAlias.ps1

function Resolve-AwtrixAlias
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('Device')][string[]]$Alias = (Get-AwtrixGlobal -Devices),

        [Parameter()]                                                                  [switch  ]$AsObject
    )

    Begin {}

    Process {

        if($AsObject)
        {
            foreach($a in $Alias)
            {
                if($Script:AwtrixAlias[$a])
                {
                    [PSCustomObject]@{

                        Alias  = $a
                        Device = $Script:AwtrixAlias[$a]
                    }
                }
                else
                {
                    [PSCustomObject]@{

                        Alias  = $a
                        Device = $a
                    }
                }
            }
        }
        else
        {
            foreach($a in $Alias)
            {
                if($Script:AwtrixAlias[$a])
                {
                    $Script:AwtrixAlias[$a]
                }
                else
                {
                    $a
                }
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Alias\Resolve-AwtrixAlias.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_App\Disable-AwtrixApp.ps1

function Disable-AwtrixApp
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                             [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -App @args})][string[]]$App,
        [Parameter(ValueFromPipelineByPropertyName)]                                               [switch  ]$Restart
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $d | Disable-Awtrix -App $App -Restart:($Restart.IsPresent)
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_App\Disable-AwtrixApp.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_App\Enable-AwtrixApp.ps1

function Enable-AwtrixApp
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                             [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -App @args})][string[]]$App,
        [Parameter(ValueFromPipelineByPropertyName)]                                               [switch  ]$Restart
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $d | Enable-Awtrix -App $App -Restart:($Restart.IsPresent)
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_App\Enable-AwtrixApp.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\$AwtrixDevJson.ps1

$Script:AwtrixDevJsonApi = [ordered]@{
    #                                                                                 # ? tested ok 
    #                                                                                 # ? tested doesn't work
    #                                                                                 # ? not tested or unknown how this should work

    #                                                                                 #    ParameterName        # Key               Type         Description                                                                                                     Default      
    #                                                                                 #    -------------------- # ---               ----         -----------                                                                                                     -------      
    Hostname             = @("hostname         ", {                          $args }) # ? Hostname             # hostname          string       Changes the hostname of your awtrix. This is used for App discovery, mDNS etc.                                  uniqeID      
    APTimeout            = @("ap_timeout       ", {                          $args }) # ? APTimeout            # ap_timeout        integer      The timeout in seconds before AWTRIX switches to AP mode if the saved WLAN was not found.                       15           
    BootSound            = @("bootsound        ", {                          $args }) # ? BootSound            # bootsound         string       Uses a custom melodie while booting                                                                                          
    MatrixLayout         = @("matrix           ", {                          $args }) # ? MatrixLayout         # matrix            integer      Changes the matrix layout (0,1 or 2)                                                                            0            
    ColorCorrection      = @("color_correction ", { ConvertTo-Awtrix -Color  $args }) # ? ColorCorrection      # color_correction  array of int Sets the colorcorrection of the matrix                                                                          [255,255,255]
    ColorTemperature     = @("color_temperature", { ConvertTo-Awtrix -Color  $args }) # ? ColorTemperature     # color_temperature array of int Sets the colortemperature of the matrix                                                                         [255,255,255]
    RotateScreen         = @("rotate_screen    ", { ConvertTo-Awtrix -Bool   $args }) # ? RotateScreen         # rotate_screen     boolean      Rotates the screen upside down                                                                                  false        
    MirrorScreen         = @("mirror_screen    ", { ConvertTo-Awtrix -Bool   $args }) # ? MirrorScreen         # mirror_screen     boolean      Mirrors the screen                                                                                              false        
    TemperatureDecPlaces = @("temp_dec_places  ", {                          $args }) # ? TemperatureDecPlaces # temp_dec_places   integer      Number of decimal places for temperature measurements                                                           0            
    SensorReading        = @("sensor_reading   ", { ConvertTo-Awtrix -Bool   $args }) # ? SensorReading        # sensor_reading    boolean      Enables or disables the reading of the Temp&Hum sensor                                                          true         
    TemperatureOffset    = @("temp_offset      ", {                          $args }) # ? TemperatureOffset    # temp_offset       float        Sets the offset for the internal temperature measurement                                                        -9           
    HumidityOffset       = @("hum_offset       ", {                          $args }) # ? HumidityOffset       # hum_offset        float        Sets the offset for the internal humidity measurement                                                           0            
    MinBrightness        = @("min_brightness   ", {                          $args }) # ? MinBrightness        # min_brightness    integer      Sets minimum brightness level for the Autobrightness control                                                    2            
    MaxBrightness        = @("max_brightness   ", {                          $args }) # ? MaxBrightness        # max_brightness    integer      Sets maximum brightness level for the Autobrightness control. On high levels, this could result in overheating! 180          
    LDRGamma             = @("ldr_gamma        ", {                          $args }) # ? LDRGamma             # ldr_gamma         float        Allows to set the gammacorrection of the brightness control                                                     3.0          
    LDRFactor            = @("ldr_factor       ", {                          $args }) # ? LDRFactor            # ldr_factor        float        This factor is calculated into the raw ldr value wich is 0-1023                                                 1.0          
    MinBattery           = @("min_battery      ", {                          $args }) # ? MinBattery           # min_battery       integer      Calibrates the minimum battery measurement by the given raw value. You will get that from the stats api         475          
    MaxBattery           = @("max_battery      ", {                          $args }) # ? MaxBattery           # max_battery       integer      Calibrates the maximum battery measurement by the given raw value. You will get that from the stats api         665          
    HomassistantPrefix   = @("ha_prefix        ", {                          $args }) # ? HomassistantPrefix   # ha_prefix         string       Sets the prefix for Homassistant discovery                                                                      homeassistant
    BackgroundEffect     = @("background_effect", { ConvertTo-Awtrix -Effect $args }) # ? BackgroundEffect     # background_effect string       Sets an effect as global background layer                                                                       -            
    StatsInterval        = @("stats_interval   ", {                          $args }) # ? StatsInterval        # stats_interval    integer      Sets the interval in milliseconds when awtrix should send its stats to HA and MQTT                              10000        
    DebugMode            = @("debug_mode       ", { ConvertTo-Awtrix -Bool   $args }) # ? DebugMode            # debug_mode        boolean      Enables serial debug outputs.                                                                                   false        
    DFPlayer             = @("dfplayer         ", { ConvertTo-Awtrix -Bool   $args }) # ? DFPlayer             # dfplayer          boolean      Enables DFPLayer for Awtrix2_conversation builds.                                                               false        
    BuzzerVolume         = @("buzzer_volume    ", { ConvertTo-Awtrix -Bool   $args }) # ? BuzzerVolume         # buzzer_volume     boolean      Activates the volume control for the buzzer, doesnt work with every tones                                       false        
    ButtonCallback       = @("button_callback  ", {                          $args }) # ? ButtonCallback       # button_callback   string       http callback url for button presses.                                                                           -            
    NewYear              = @("new_year         ", { ConvertTo-Awtrix -Bool   $args }) # ? NewYear              # new_year          boolean      Displays fireworks and plays a jingle at newyear.                                                               false        
}

$Script:AwtrixDevJsonApiRaw2PS = [ordered]@{}

foreach($kv in $Script:AwtrixDevJsonApi.GetEnumerator())
{
    $Script:AwtrixDevJsonApiRaw2PS[$kv.Value[0].Trim()] = $kv.Key
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\$AwtrixDevJson.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Get-AwtrixDevJson.ps1

function Get-AwtrixDevJson
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]  [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][Alias("ValueOnly")][switch  ]$JsonOnly,
        [Parameter(ValueFromPipelineByPropertyName)]                    [switch  ]$AsHashTable
    )

    Begin {}

    Process {

        foreach($o in (Resolve-AwtrixAlias $Device -AsObject))
        {
            $content = $o.Alias | Get-AwtrixItemContent -Path "/dev.json" -ContentOnly -ErrorAction SilentlyContinue

            if($AsHashTable)
            {
                $DevJson = [ordered]@{}

                foreach($property in $content.PSObject.Properties)
                {
                    $DevJson[$property.Name] = $property.Value
                }
            }
            else
            {
                $DevJson = $content
            }

            if($JsonOnly)
            {
                $DevJson
            }
            else
            {
                [PSCustomObject]@{

                    Device  = $o.Alias
                    DevJson = $DevJson
                }
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Get-AwtrixDevJson.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Remove-AwtrixDevJson.ps1

function Remove-AwtrixDevJson
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)]                    [switch]$Restart
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $d | Remove-AwtrixItem -Path "/dev.json"
        
            if($Restart.IsPresent)
            {
                $d | Restart-Awtrix
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Remove-AwtrixDevJson.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Remove-AwtrixDevJsonProperty.ps1

function Remove-AwtrixDevJsonProperty
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)]                  [string[]]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Restart
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            if('*' -in $Name)
            {
                $devJson = [ordered]@{}
            }
            else
            {
                $devJson = $d | Get-AwtrixDevJson -Value -AsHashTable

                foreach($n in $Name)
                {
                    $devJson.Remove($n)
                }
            }

            $d | Set-AwtrixItemContent -Path "/dev.json" -Text ($devJson | ConvertTo-Json)
            
            if($Restart.IsPresent)
            {
                $d | Restart-Awtrix
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Remove-AwtrixDevJsonProperty.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Set-AwtrixDevJson.ps1

function Set-AwtrixDevJson
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]              [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][Alias('Json','DevJson','Text')][object  ]$Object,

        [Parameter(ValueFromPipelineByPropertyName)]                                [switch  ]$Restart
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            if($Object -is [string])
            {
                $d | Set-AwtrixItemContent -Path "/dev.json" -Text  $Object
            }
            else
            {
                $d | Set-AwtrixItemContent -Path "/dev.json" -Text ($Object | ConvertTo-Json)
            }

            if($Restart.IsPresent)
            {
                $d | Restart-Awtrix
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Set-AwtrixDevJson.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Set-AwtrixDevJsonProperty.ps1

function Set-AwtrixDevJsonProperty
{
    [CmdletBinding(DefaultParameterSetName='KeyValue')]
    param(
        [Parameter(ParameterSetName='KeyValue' )]
        [Parameter(ParameterSetName='HashTable')][Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]    [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ParameterSetName='KeyValue' )][Parameter(ValueFromPipelineByPropertyName)]                      [string  ]$Name,
        [Parameter(ParameterSetName='KeyValue' )][Parameter(ValueFromPipelineByPropertyName)]                                $Value,

                                                                                                                      [Alias('Dictionary'
                                                                                                                            ,'Object'
                                                                                                                            ,'Property')]
        [Parameter(ParameterSetName='HashTable')][Parameter(ValueFromPipelineByPropertyName)][System.Collections.IDictionary]$HashTable,

        [Parameter(ParameterSetName='KeyValue' )]
        [Parameter(ParameterSetName='HashTable')][Parameter(ValueFromPipelineByPropertyName)]                        [switch]$Restart
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $devJson = $d | Get-AwtrixDevJson -Value -AsHashTable

            switch($PSCmdlet.ParameterSetName)
            {
                'KeyValue'  { $devJson[$Name] = $Value }

                'HashTable' { $HashTable.GetEnumerator() | ForEach-Object { $devJson[$_.Key] = $_.Value } }
            }

            $d | Set-AwtrixItemContent -Path "/dev.json" -Text ($devJson | ConvertTo-Json)

            if($Restart.IsPresent)
            {
                $d | Restart-Awtrix
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_DevJson\Set-AwtrixDevJsonProperty.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Display\Disable-AwtrixDisplay.ps1

function Disable-AwtrixDisplay
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices)
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $d | Disable-Awtrix -Display
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Display\Disable-AwtrixDisplay.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Display\Enable-AwtrixDisplay.ps1

function Enable-AwtrixDisplay
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices)
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $d | Enable-Awtrix -Display
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Display\Enable-AwtrixDisplay.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Drawing\New-AwtrixDrawing.ps1

<#
    Drawing Instructions

    Please note: Depending on the number of objects, the RAM usage can be very high. This could cause freezes or reboots.
    It's important to be mindful of the number of objects and the complexity of the drawing instructions to avoid performance issues.

    Command ArrayValues          Description                                                                            
    ------- -----------          -----------                                                                            
    dp      [x, y, cl]           Draw a pixel at position (x, y) with color cl                                          
    dl      [x0, y0, x1, y1, cl] Draw a line from (x0, y0) to (x1, y1) with color cl                                    
    dr      [x, y, w, h, cl]     Draw a rectangle with top-left corner at (x, y), width w, height h, and color cl       
    df      [x, y, w, h, cl]     Draw a filled rectangle with top-left corner at (x, y), width w, height h, and color cl
    dc      [x, y, r, cl]        Draw a circle with center at (x, y), radius r, and color cl                            
    dfc     [x, y, r, cl]        Draw a filled circle with center at (x, y), radius r, and color cl                     
    dt      [x, y, t, cl]        Draw text t with top-left corner at (x, y) and color cl                                
    db      [x, y, w, h, [bmp]]  Draws a RGB888 bitmap array [bmp] with top-left corner at (x, y) and size of (w, h)    

    {"draw":[  
    {"dc": [28, 4, 3, "#FF0000"]},  
    {"dr": [20, 4, 4, 4, "#0000FF"]},  
    {"dt": [0, 0, "Hello", "#00FF00"]}  
    ]}  
#>

function New-AwtrixDrawing
{
    [CmdletBinding()]
    [Alias("Drawing","Draw")]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][object[]]$Instruction
    )

    Begin {

        $Drawing = [System.Collections.Generic.List[object]]::new()
    }

    Process {
        
        foreach($i in $Instruction)
        {
            if($i -is [scriptblock])
            {
                $Drawing.AddRange(@(( . $i)))
            }
            else
            {
                $Drawing.Add($i)
            }
        }
    }

    End {

        $Drawing
    }
}

function New-AwtrixPixel    {[CmdletBinding()][Alias("Pixel"           )] param([ValidateCount(2,2)][uint32[]]$xy,                                        [ArgumentCompleter({Get-AwtrixArg -Color @args})][object[]]$Color               ) [PSCustomObject]@{   "dp"                          = @($xy[0], $xy[1],                 (ConvertTo-AwtrixColor $Color) ) } } # dp      [x, y, cl]           Draw a pixel at position (x, y) with color cl
function New-AwtrixLine     {[CmdletBinding()][Alias("Line"            )] param([ValidateCount(4,4)][uint32[]]$xy,                                        [ArgumentCompleter({Get-AwtrixArg -Color @args})][object[]]$Color               ) [PSCustomObject]@{   "dl"                          = @($xy[0], $xy[1], $xy[2], $xy[3], (ConvertTo-AwtrixColor $Color) ) } } # dl      [x0, y0, x1, y1, cl] Draw a line from (x0, y0) to (x1, y1) with color cl
function New-AwtrixRectangle{[CmdletBinding()][Alias("Rectangle","Rect")] param([ValidateCount(2,2)][uint32[]]$xy, [ValidateCount(2,2)][uint32[]]$wh,     [ArgumentCompleter({Get-AwtrixArg -Color @args})][object[]]$Color, [switch]$Fill) [PSCustomObject]@{ @("dr", "df" )[$Fill.IsPresent] = @($xy[0], $xy[1], $wh[0], $wh[1], (ConvertTo-AwtrixColor $Color) ) } } # dr, df  [x, y, w, h, cl]     Draw a rectangle with top-left corner at (x, y), width w, height h, and color cl
function New-AwtrixCircle   {[CmdletBinding()][Alias("Circle"          )] param([ValidateCount(2,2)][uint32[]]$xy,                     [uint32  ]$Radius, [ArgumentCompleter({Get-AwtrixArg -Color @args})][object[]]$Color, [switch]$Fill) [PSCustomObject]@{ @("dc", "dfc")[$Fill.IsPresent] = @($xy[0], $xy[1], $Radius,        (ConvertTo-AwtrixColor $Color) ) } } # dc, dfc [x, y, r, cl]        Draw a circle with center at (x, y), radius r, and color cl
function New-AwtrixText     {[CmdletBinding()][Alias("Text"            )] param([ValidateCount(2,2)][uint32[]]$xy,                     [string  ]$Text,   [ArgumentCompleter({Get-AwtrixArg -Color @args})][object[]]$Color               ) [PSCustomObject]@{   "dt"                          = @($xy[0], $xy[1], $Text,          (ConvertTo-AwtrixColor $Color) ) } } # dt      [x, y, t, cl]        Draw text t with top-left corner at (x, y) and color cl
function New-AwtrixBitmap   {[CmdletBinding()][Alias("Bitmap"          )] param([ValidateCount(2,2)][uint32[]]$xy, [ValidateCount(2,2)][uint32[]]$wh,     [ArgumentCompleter({Get-AwtrixArg -Color @args})][object[]]$Color               ) [PSCustomObject]@{   "db"                          = @($xy[0], $xy[1], $wh[0], $wh[1], (ConvertTo-AwtrixColor $Color) ) } } # db      [x, y, w, h, [bmp]]  Draws a RGB888 bitmap array [bmp] with top-left corner at (x, y) and size of (w, h)

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Drawing\New-AwtrixDrawing.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Effect\Get-AwtrixEffectSettings.ps1

function Get-AwtrixEffectSettings
{
    [CmdletBinding(DefaultParameterSetName='List')]
    param(
        [Parameter(ParameterSetName='Name')][Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][ArgumentCompleter({Get-AwtrixArg -Effect  @args})][string[]]$Name,

        [Parameter(ParameterSetName='Name')][Parameter(ValueFromPipelineByPropertyName)]                                                                     [uint32  ]$Speed,
        [Parameter(ParameterSetName='Name')][Parameter(ValueFromPipelineByPropertyName)]                  [ArgumentCompleter({Get-AwtrixArg -Palette @args})][string  ]$Palette,
        [Parameter(ParameterSetName='Name')][Parameter(ValueFromPipelineByPropertyName)]                                                                     [switch  ]$Blend,

        [Parameter(ParameterSetName='Name')][Parameter(ValueFromPipelineByPropertyName)]                                                 [Alias("ValueOnly")][switch  ]$SettingsOnly,

        [Parameter(ParameterSetName='List')][Parameter(ValueFromPipelineByPropertyName)]                                                                     [switch  ]$List
    )

    Begin {
    
        $effects = [ordered]@{}

        foreach($item in @(

            [ordered]@{ effect = "Fade"          ; effectSettings = [ordered]@{ speed = 1; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "MovingLine"    ; effectSettings = [ordered]@{ speed = 1; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "BrickBreaker"  ; effectSettings = [ordered]@{                                                } }
            [ordered]@{ effect = "PingPong"      ; effectSettings = [ordered]@{ speed = 8; palette = "Rainbow";                } }
            [ordered]@{ effect = "Radar"         ; effectSettings = [ordered]@{ speed = 1; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "Checkerboard"  ; effectSettings = [ordered]@{ speed = 1; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "Fireworks"     ; effectSettings = [ordered]@{ speed = 1; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "PlasmaCloud"   ; effectSettings = [ordered]@{ speed = 3; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "Ripple"        ; effectSettings = [ordered]@{ speed = 3; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "Snake"         ; effectSettings = [ordered]@{ speed = 3; palette = "Rainbow";                } }
            [ordered]@{ effect = "Pacifica"      ; effectSettings = [ordered]@{ speed = 3; palette = "Ocean  "; blend = $true  } }
            [ordered]@{ effect = "TheaterChase"  ; effectSettings = [ordered]@{ speed = 3; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "Plasma"        ; effectSettings = [ordered]@{ speed = 2; palette = "Rainbow"; blend = $true  } }
            [ordered]@{ effect = "Matrix"        ; effectSettings = [ordered]@{ speed = 8;                                     } }
            [ordered]@{ effect = "SwirlIn"       ; effectSettings = [ordered]@{ speed = 4; palette = "Rainbow";                } }
            [ordered]@{ effect = "SwirlOut"      ; effectSettings = [ordered]@{ speed = 4; palette = "Rainbow";                } }
            [ordered]@{ effect = "LookingEyes"   ; effectSettings = [ordered]@{                                                } }
            [ordered]@{ effect = "TwinklingStars"; effectSettings = [ordered]@{ speed = 4; palette = "Ocean  "; blend = $false } }
            [ordered]@{ effect = "ColorWaves"    ; effectSettings = [ordered]@{ speed = 3; palette = "Rainbow"; blend = $true  } }
        
        )){ $effects[$item.effect] = $item }
    }

    Process {

        switch($PSCmdlet.ParameterSetName)
        {
            'List' { @() + $effects.Keys }
            
            'Name' {

                if('*' -in $Name)
                {
                    $Name = @() + $effects.Keys
                }

                foreach($n in $Name)
                {
                    if($n -in $effects.Keys)
                    {
                        $result = $effects[$n].PsObject.Copy()
                    }
                    else
                    {
                        $result = [ordered]@{ effect = $n; effectSettings = [ordered]@{} }
                    }

                    if($PSBoundParameters.ContainsKey('Speed'  )) { $result.effectSettings["speed"  ] = $Speed           }
                    if($PSBoundParameters.ContainsKey('Palette')) { $result.effectSettings["palette"] = $Palette         }
                    if($PSBoundParameters.ContainsKey('Blend'  )) { $result.effectSettings["blend"  ] = $Blend.IsPresent }

                    if($SettingsOnly)
                    {
                        $result.effectSettings
                    }
                    else
                    {
                        $result
                    }
                }
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Effect\Get-AwtrixEffectSettings.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Global\$AwtrixGlobal.ps1

$Script:AwtrixGlobal = [PSCustomObject]@{

    Devices = @()
    Clients = @()
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Global\$AwtrixGlobal.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Global\Get-AwtrixGlobal.ps1

function Get-AwtrixGlobal
{
    [CmdletBinding(DefaultParameterSetName='None')]
    param(
        [Parameter(ParameterSetName='Devices')][switch]$Devices,
        [Parameter(ParameterSetName='Clients')][switch]$Clients
    )

    if($PSCmdlet.ParameterSetName -eq 'None')
    {
        $Script:AwtrixGlobal
    }
    else
    {
        $Script:AwtrixGlobal."$($PSCmdlet.ParameterSetName)"
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Global\Get-AwtrixGlobal.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Global\Set-AwtrixGlobal.ps1

function Set-AwtrixGlobal
{
    [CmdletBinding()]
    param(
        [Parameter()][string[]]$Devices,
        [Parameter()][string[]]$Clients,

        [Parameter()][switch  ]$Persist
    )

    if($PSBoundParameters.ContainsKey('Devices')) { $Script:AwtrixGlobal.Devices = $Devices }
    if($PSBoundParameters.ContainsKey('Clients')) { $Script:AwtrixGlobal.Clients = $Clients }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Global\Set-AwtrixGlobal.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Helper\Get-AwtrixModulePath.ps1

function Get-AwtrixModulePath
{
    [CmdletBinding(DefaultParameterSetName='None')]
    param(
        [Parameter(ParameterSetName='CustomApps')][switch]$CustomApps,
        [Parameter(ParameterSetName='Icons'     )][switch]$Icons,
        [Parameter(ParameterSetName='Images'    )][switch]$Images,
        [Parameter(ParameterSetName='Melodies'  )][switch]$Melodies,
        [Parameter(ParameterSetName='Palettes'  )][switch]$Palettes
    )

    if($PSCmdlet.ParameterSetName -eq '-None')
    {
        "$($Script:ModulePath)"
    }
    else
    {
        "$($Script:ModulePath)\$($PSCmdlet.ParameterSetName)".TrimEnd('\')
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Helper\Get-AwtrixModulePath.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Helper\New-AwtrixApiBody.ps1

function New-AwtrixApiBody($Api, $BoundParameters)
{
    function AddBodyProperty([string]$Name, $Value)
    {
        if($Api.Contains($Name))
        {
            $property = (($Api[$Name])[0]).Trim()

            if($Value -is [array])
            {
                if($Value.Length -eq 1)
                {
                    if($Value[0] -is [scriptblock])
                    {
                        $Value = . $Value[0]
                    }
                }
            }
            
            $result   = (($Api[$Name])[1]).InvokeReturnAsIs($Value)

            if($result -is [array])
            {
                $Body[$property] = @(); $result | ForEach-Object { $Body[$property] += $_ }
            }
            else
            {
                $Body[$property] = $result
            }
        }
    }

    $Body = @{}

    foreach($item in $BoundParameters.GetEnumerator())
    {
        AddBodyProperty -Name $item.Key -Value $item.Value
    }

    $Body
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Helper\New-AwtrixApiBody.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Indicator\Disable-AwtrixIndicator.ps1

function Disable-AwtrixIndicator
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                                   [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Indicator @args})][string[]]$Indicator
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $d | Disable-Awtrix -Indicator $Indicator
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Indicator\Disable-AwtrixIndicator.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Indicator\Enable-AwtrixIndicator.ps1

function Enable-AwtrixIndicator
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                                   [string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Indicator @args})][string[]]$Indicator,
        [Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color     @args})][object[]]$Color = "Green",
        [Parameter(ValueFromPipelineByPropertyName)]                                                     [uint32  ]$Blink,
        [Parameter(ValueFromPipelineByPropertyName)]                                                     [uint32  ]$Fade
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $Splat = @{}

            if($Color) { $Splat["Color"] = $Color }
            if($Blink) { $Splat["Blink"] = $Blink }
            if($Fade ) { $Splat["Fade" ] = $Fade  }

            $d | Enable-Awtrix -Indicator $Indicator @Splat
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Indicator\Enable-AwtrixIndicator.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Icon\Get-AwtrixIconFromModule.ps1

function Get-AwtrixIconFromModule
{
    [CmdletBinding(DefaultParameterSetName='List')]
    param(
        [Parameter(ParameterSetName='List' )][switch  ]$List,

        [Parameter(ParameterSetName='Name' )]
        [Parameter(ParameterSetName='Like' )]
        [Parameter(ParameterSetName='Match')][string  ]$Path,

        [Parameter(ParameterSetName='Name' )][string[]]$Name,

        [Parameter(ParameterSetName='Like' )][string[]]$Like,

        [Parameter(ParameterSetName='Match')][string[]]$Match
    )

    Begin {
    
        function NewLocalItemObject($fileInfo)
        {
            [PSCustomObject]@{

                Name     = $fileInfo.BaseName
                FullName = $fileInfo
            }
        }

        $SourcePath = "$(Get-AwtrixModulePath -Icons)\"; $lenSourcePath = $SourcePath.Length   
        $Extension  = ".gif"                           ; $lenExtension  = $Extension.Length
    }

    Process {
    
        if($Path) { if($Path[-1] -notin @('\', '/')) { $Path += "\" } }

        switch($PSCmdlet.ParameterSetName)
        {
            List  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse | ForEach-Object { $_.FullName.Substring($lenSourcePath, $_.FullName.Length - ($lenSourcePath + $lenExtension)) } }

            Name  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -in     $Name             } | ForEach-Object { NewLocalItemObject $_ } }
            Like  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -like   $Like             } | ForEach-Object { NewLocalItemObject $_ } }
            Match { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -match ($Match -join '|') } | ForEach-Object { NewLocalItemObject $_ } }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Icon\Get-AwtrixIconFromModule.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Icon\ToDo-Set-AwtrixIcon.ps1

function Set-AwtrixIcon
{
    [CmdletBinding()]

    [Alias('New-AwtrixIcon')]

    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices)
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Icon\ToDo-Set-AwtrixIcon.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Melody\Get-AwtrixMelodyFromModule.ps1

function Get-AwtrixMelodyFromModule
{
    [CmdletBinding(DefaultParameterSetName='List')]
    param(
        [Parameter(ParameterSetName='List' )][switch  ]$List,

        [Parameter(ParameterSetName='Name' )]
        [Parameter(ParameterSetName='Like' )]
        [Parameter(ParameterSetName='Match')][string  ]$Path,

        [Parameter(ParameterSetName='Name' )][string[]]$Name,

        [Parameter(ParameterSetName='Like' )][string[]]$Like,

        [Parameter(ParameterSetName='Match')][string[]]$Match
    )

    Begin {
    
        function NewLocalItemObject($fileInfo)
        {
            $object = Get-Content $fileInfo.FullName -Raw | ConvertFrom-Json

            [PSCustomObject]@{

                Name     = $fileInfo.BaseName

                Tune     = $object.RTTTL
                Origin   = $object.Origin

                FullName = $fileInfo
            }
        }

        $SourcePath = "$(Get-AwtrixModulePath -Melodies)\"; $lenSourcePath = $SourcePath.Length   
        $Extension  = ".json"                             ; $lenExtension  = $Extension.Length
    }

    Process {
    
        if($Path) { if($Path[-1] -notin @('\', '/')) { $Path += "\" } }

        switch($PSCmdlet.ParameterSetName)
        {
            List  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse | ForEach-Object { $_.FullName.Substring($lenSourcePath, $_.FullName.Length - ($lenSourcePath + $lenExtension)) } }

            Name  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -in     $Name             } | ForEach-Object { NewLocalItemObject $_ } }
            Like  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -like   $Like             } | ForEach-Object { NewLocalItemObject $_ } }
            Match { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -match ($Match -join '|') } | ForEach-Object { NewLocalItemObject $_ } }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Melody\Get-AwtrixMelodyFromModule.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Melody\Set-AwtrixMelody.ps1

function Set-AwtrixMelody
{
    [CmdletBinding(DefaultParameterSetName='FromFile')]

    [Alias('New-AwtrixMelody')]

    param(
        [Parameter(ParameterSetName='FromFile'             )]
        [Parameter(ParameterSetName='FromFilePreserve'     )]
        [Parameter(ParameterSetName='FromFilePreserveBelow')]
        [Parameter(ParameterSetName='RTTTL'                )][Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)] [string[]]$Device = (Get-AwtrixGlobal -Devices),                                           
                                          
        [Parameter(ParameterSetName='FromFile'             )]
        [Parameter(ParameterSetName='FromFilePreserve'     )]
        [Parameter(ParameterSetName='FromFilePreserveBelow')]
        [Parameter(ParameterSetName='RTTTL'                )][Parameter(ValueFromPipelineByPropertyName)]                   [string  ]$Path,

        [Parameter(ParameterSetName='FromFile'             )]
        [Parameter(ParameterSetName='FromFilePreserve'     )]
        [Parameter(ParameterSetName='FromFilePreserveBelow')][Parameter(ValueFromPipelineByPropertyName)][Alias("FullName")][object[]]$FromFile,

        [Parameter(ParameterSetName='RTTTL'                )][Parameter(ValueFromPipelineByPropertyName)]                   [string  ]$RTTTL,

        [Parameter(ParameterSetName='FromFilePreserve'     )]                                                               [switch  ]$PreserveSubdirs,
        [Parameter(ParameterSetName='FromFilePreserveBelow')]                                                               [string  ]$PreserveSubdirsBelow
    )

    Begin {

        $ModulePathMelodies = "$(Get-AwtrixModulePath -Melodies)\"
    }

    Process {

        switch -Wildcard ($PSCmdlet.ParameterSetName)
        {
            RTTTL     { if(-not $Path) { $Path = $RTTTL.Split(':',2)[0] }; $Device | Set-AwtrixItemContent -Path "MELODIES\$($Path).txt" -Text $RTTTL }

            FromFile* {
            
                if($Path) { if($Path[-1] -notin @('\', '/')) { $Path += "\" } }

                foreach($object in $FromFile)
                {
                    if(($object -is [System.IO.FileInfo]) -or ($object -is [string]))
                    {
                        $file = $object | Get-Item

                        $PreservePath = ""

                        if($PreserveSubdirs)
                        {
                            if($file.FullName -like "$($ModulePathMelodies)*")
                            {
                                $PreservePath = $file.DirectoryName.Substring($ModulePathMelodies.Length)
                            }
                        }
                        elseif($PreserveSubdirsBelow)
                        {
                            $i = "$($file.DirectoryName)\".ToUpper().IndexOf("\$PreserveSubdirsBelow\".ToUpper())

                            if($i -ge 0)
                            {
                                $PreservePath = "$($file.DirectoryName)".Substring($i + $PreserveSubdirsBelow.Length + 2)
                            }
                        }

                        if($PreservePath) { $PreservePath += "\" } 

                        $content = $file | Get-Content -Raw

                        $RTTTL = switch($file.Extension)
                        {
                            '.txt'  {  $content }
                            '.json' { ($content | ConvertFrom-Json).RTTTL }
                        }

                        if($RTTTL)
                        {
                            $Device | Set-AwtrixItemContent -Path "MELODIES\$($Path)$($PreservePath)$($file.BaseName).txt" -Text $RTTTL
                        }
                    }
                    elseif($object)
                    {
                        $Device | Set-AwtrixItemContent -Path "MELODIES\$($Path)$($object.Name).txt" -Text $object.RTTTL
                    }
                }
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Melody\Set-AwtrixMelody.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Palette\Get-AwtrixPaletteFromModule.ps1

function Get-AwtrixPaletteFromModule
{
    [CmdletBinding(DefaultParameterSetName='List')]
    param(
        [Parameter(ParameterSetName='List' )][switch  ]$List,

        [Parameter(ParameterSetName='Name' )]
        [Parameter(ParameterSetName='Like' )]
        [Parameter(ParameterSetName='Match')][string  ]$Path,

        [Parameter(ParameterSetName='Name' )][string[]]$Name,

        [Parameter(ParameterSetName='Like' )][string[]]$Like,

        [Parameter(ParameterSetName='Match')][string[]]$Match
    )

    Begin {
    
        function NewLocalItemObject($fileInfo)
        {
            [PSCustomObject]@{

                Name     = $fileInfo.BaseName
                FullName = $fileInfo
            }
        }

        $SourcePath = "$(Get-AwtrixModulePath -Palettes)\"; $lenSourcePath = $SourcePath.Length   
        $Extension  = ".txt"                              ; $lenExtension  = $Extension.Length
    }

    Process {
    
        if($Path) { if($Path[-1] -notin @('\', '/')) { $Path += "\" } }

        switch($PSCmdlet.ParameterSetName)
        {
            List  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse | ForEach-Object { $_.FullName.Substring($lenSourcePath, $_.FullName.Length - ($lenSourcePath + $lenExtension)) } }

            Name  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -in     $Name             } | ForEach-Object { NewLocalItemObject $_ } }
            Like  { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -like   $Like             } | ForEach-Object { NewLocalItemObject $_ } }
            Match { Get-ChildItem -Path "$($SourcePath)$($Path)*$($Extension)" -Recurse |   Where-Object { $_.BaseName -match ($Match -join '|') } | ForEach-Object { NewLocalItemObject $_ } }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Palette\Get-AwtrixPaletteFromModule.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Palette\ToDo-Set-AwtrixPalette.ps1

function Set-AwtrixPalette
{
    [CmdletBinding()]

    [Alias('New-AwtrixPalette')]

    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)][ValidateCount(16,16)][ArgumentCompleter({Get-AwtrixArg -Color @args})][string[]]$Color
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $Color | ForEach-Object { ConvertTo-AwtrixColor $_ } | ForEach-Object ToUpper
        }
    }

    End {}
}

<#
    $Script:AwtrixValueConverter["ColorMap"].Awtrix2PS[

        "0000FF", # Deep blue sky at the horizon's edge
        "0047AB", # Lighter sky
        "0080FF", # Even lighter sky
        "00BFFF", # Light blue sky
        "87CEEB", # Slightly cloudy sky
        "87CEFA", # Light blue sky
        "F0E68C", # Light clouds
        "FFD700", # Start of sun colors
        "FFA500", # Darker sun colors
        "FF4500", # Even darker sun colors
        "FF6347", # Red-orange sun colors
        "FF4500", # Dark sun colors
        "FFA500", # Bright sun colors
        "FFD700", # Bright yellow sun colors
        "FFFFE0", # Very bright sun colors
        "FFFFFF"  # White sun colors, very bright light
    ]
#>

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\_Palette\ToDo-Set-AwtrixPalette.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Get-AwtrixChildItem.ps1

function Get-AwtrixChildItem
{
    [CmdletBinding()]

    [Alias("Get-AwtrixIcons"
          ,"Get-AwtrixCustomApps"
          ,"Get-AwtrixMelodies"
          ,"Get-AwtrixPalettes"
          )]

    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Path,

       #[Parameter(ValueFromPipelineByPropertyName)]                  [string[]]$Filter, # Wildcards: '*', '?', '[...]' # Todo !!!

        [Parameter()]                                                 [switch  ]$Recurse
    )

    Begin {

        function PrivateGetChildItem($Device, $Path, $Recurse)
        {
            try { $response = Invoke-RestMethod -Method Get -Uri "http://$($Device)/list?dir=$($Path)" -Verbose:$false -ErrorAction SilentlyContinue } catch { $response = $null }
    
            $items = @($response | Sort-Object -Property type, name)

            for($iz = 0; $iz -lt $items.Count; $iz++)
            {
                $items[$iz].name = "$($Path.TrimEnd([char[]]'/'))/$($items[$iz].name)"
                $items[$iz]

                if($Recurse)
                {
                    if(($items[$iz].type -eq "dir"))
                    {
                        PrivateGetChildItem -Device $Device -Path $items[$iz].name -Recurse $Recurse
                    }
                }
            }
        }

        $result = [ordered]@{}

        $Prefix = ""

        if($PSCmdlet.MyInvocation.InvocationName -ne "Get-AwtrixChildItem")
        {
            $Prefix = "/$($PSCmdlet.MyInvocation.InvocationName.Substring(10))/".ToUpper()
        }
    }

    Process {
    
        foreach($o in (Resolve-AwtrixAlias $Device -AsObject))
        {
            $result[$o.Alias] = PrivateGetChildItem -Device $o.Device -Path "$Prefix$Path" -Recurse $Recurse
        }
    }

    End {

        $result
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Get-AwtrixChildItem.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Get-AwtrixItemContent.ps1

function Get-AwtrixItemContent
{
    [CmdletBinding(DefaultParameterSetName='As')]
    param(
        [Parameter(ParameterSetName='OutFile')]
        [Parameter(ParameterSetName='As'     )][Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                    [string[]]$Device = (Get-AwtrixGlobal -Devices),                                           

        [Parameter(ParameterSetName='OutFile')]                                                                       
        [Parameter(ParameterSetName='As'     )][Parameter(ValueFromPipelineByPropertyName)]                                      [string  ]$Path,

        [Parameter(ParameterSetName='OutFile')][Parameter(ValueFromPipelineByPropertyName)]                                      [string  ]$OutFile,
        [Parameter(ParameterSetName='As'     )][Parameter(ValueFromPipelineByPropertyName)][ValidateSet('Bytes','Text','Object')][string  ]$As,
        
        [Parameter(ParameterSetName='OutFile')]
        [Parameter(ParameterSetName='As'     )][Parameter(ValueFromPipelineByPropertyName)][Alias("ValueOnly")]                  [switch  ]$ContentOnly
    )

    Begin {}

    Process {

        foreach($o in (Resolve-AwtrixAlias $Device -AsObject))
        {
            $webClient = [System.Net.WebClient]::new()

            $Path     = $Path.TrimStart('/')

            $dirName  = [System.IO.Path]::GetDirectoryName($Path).Split([char[]]@('\','/'))
            $fileName = [System.IO.Path]::GetFileName($Path)

            $url = "http://$($o.Device)/$($Path)"

            switch($PSCmdlet.ParameterSetName)
            {
                'OutFile' {

                    $content = (((($OutFile -replace '{Device}',"$($o.Alias)") -replace '{Path\*}',"$($dirName -join '\')") -replace '{Path}',"$($dirName[1..($dirName.Length)] -join '\')") -replace '{Name}',"$($fileName)").Replace('/','\')

                    [void](mkdir ([System.IO.Path]::GetDirectoryName($content)) -ErrorAction SilentlyContinue)

                    $webClient.DownloadFile($url, $content)
                }

                'As' {

                    $content = switch($As)
                    {
                        'Bytes'  { $webClient.DownloadData(  $url) }
                        'Text'   { $webClient.DownloadString($url) }

                        'Object' { $webClient.DownloadString($url) | ConvertFrom-Json }

                        default  {

                            switch([System.IO.Path]::GetExtension($Path))
                            {
                                '.txt'  { $webClient.DownloadString($url) }
                                '.text' { $webClient.DownloadString($url) }
                                '.html' { $webClient.DownloadString($url) }

                                '.json' { $webClient.DownloadString($url) | ConvertFrom-Json }

                                default { $webClient.DownloadData(  $url) }
                            }
                        }
                    }
                }
            }

            if($ContentOnly)
            {
                $content
            }
            else
            {
                [PSCustomObject]@{

                    Device  = $o.Alias
                    Path    = $Path
                    Content = $content
                }
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Get-AwtrixItemContent.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\New-AwtrixDirectory.ps1

function New-AwtrixDirectory
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Path,

        [Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$PassThru
    )

    Begin {}

    Process {

        $Path     = "/$(($Path).Trim('/'))/"

        $Boundary = "----WebKitFormBoundary$(New-Guid)"

        $body     = @"
--$($Boundary)
Content-Disposition: form-data; name="path"

$($Path)
--$($Boundary)--

"@
        $bytes = [System.Text.Encoding]::Default.GetBytes($body)

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            Write-Verbose ($body)

            $result = Invoke-WebRequest -Method PUT -Uri "http://$($d)/edit" -Body $bytes -Headers @{ "Content-Length" = $bytes.Count } -ContentType "multipart/form-data; boundary=$($Boundary)" -UseBasicParsing -Verbose:$false
            
            if($PassThru) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\New-AwtrixDirectory.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Remove-AwtrixItem.ps1

function Remove-AwtrixItem
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Path,
    
        [Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$PassThru
)

    Begin {}

    Process {

        $Path     = "/$(($Path).TrimStart('/'))"

        $Boundary = "----WebKitFormBoundary$(New-Guid)"

        $body     = @"
--$($Boundary)
Content-Disposition: form-data; name="path"

$($Path)
--$($Boundary)--

"@
        $bytes = [System.Text.Encoding]::Default.GetBytes($body)

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            Write-Verbose ($body)

            $result = Invoke-WebRequest -Method DELETE -Uri "http://$($d)/edit" -Body $bytes -Headers @{ "Content-Length" = $bytes.Count } -ContentType "multipart/form-data; boundary=$($Boundary)" -UseBasicParsing -Verbose:$false
            
            if($PassThru) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Remove-AwtrixItem.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Rename-AwtrixItem.ps1

function Rename-AwtrixItem
{
    [CmdletBinding()]

    [Alias('Move-AwtrixItem')]

    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Path,
        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$NewName,

        [Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$PassThru
    )

    Begin {}

    Process {

        $Path     = "/$(($Path   ).TrimStart('/'))"
        $NewName  = "/$(($NewName).TrimStart('/'))"

        $Boundary = "----WebKitFormBoundary$(New-Guid)"

        $body     = @"
--$($Boundary)
Content-Disposition: form-data; name="path"

$($NewName)
--$($Boundary)
Content-Disposition: form-data; name="src"

$($Path)
--$($Boundary)--

"@
        $bytes = [System.Text.Encoding]::Default.GetBytes($body)

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            Write-Verbose ($body)

            $result = Invoke-WebRequest -Method PUT -Uri "http://$($d)/edit" -Body $bytes -Headers @{ "Content-Length" = $bytes.Count } -ContentType "multipart/form-data; boundary=$($Boundary)" -UseBasicParsing -Verbose:$false

            if($PassThru) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Rename-AwtrixItem.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Set-AwtrixItemContent.ps1

function Set-AwtrixItemContent
{
    [CmdletBinding()]

    [Alias("New-AwtrixItem")]

    param(
        [Parameter(ParameterSetName='FromFile' )]
        [Parameter(ParameterSetName='Text'     )]
        [Parameter(ParameterSetName='Bytes'    )][Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),                                           
                                          
        [Parameter(ParameterSetName='FromFile' )]
        [Parameter(ParameterSetName='Text'     )]
        [Parameter(ParameterSetName='Bytes'    )][Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Path,

        [Parameter(ParameterSetName='FromFile' )][Parameter(ValueFromPipelineByPropertyName)]                  [object  ]$FromFile,
        [Parameter(ParameterSetName='Text'     )][Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Text,
        [Parameter(ParameterSetName='Bytes'    )][Parameter(ValueFromPipelineByPropertyName)]                  [byte[]  ]$Bytes,

        [Parameter(ParameterSetName='FromFile' )]
        [Parameter(ParameterSetName='Text'     )]
        [Parameter(ParameterSetName='Bytes'    )][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$PassThru
    )

    Begin {

        $crlf = "$([char]13)$([char]10)"
    }

    Process {

        $ContentType = switch -Wildcard ($Path)
        {
            "*.gif"  { "image/gif"  }
            "*.jpg"  { "image/jpeg" }

            default  { "text/plain" }
        }

        $Boundary       = "----WebKitFormBoundary$(New-Guid)"

        $BoundaryHeader = "--$($Boundary)$($crlf)Content-Disposition: form-data; name=`"data`"; filename=`"$($Path)`"$($crlf)Content-Type: $($ContentType)$($crlf)$($crlf)"
        $BoundaryFooter = "$($crlf)--$($Boundary)--$($crlf)"

        $bytesHeader    = [System.Text.Encoding]::Default.GetBytes($BoundaryHeader)
        $bytesFooter    = [System.Text.Encoding]::Default.GetBytes($BoundaryFooter)

        switch($PSCmdlet.ParameterSetName)
        {
            'FromFile' { $bytesContent = [System.IO.File]::ReadAllBytes("$Path") }

            'Text'     { $bytesContent = [System.Text.Encoding]::Default.GetBytes($Text) }

            'Bytes'    { $bytesContent = $Bytes }
        }

        [byte[]]$bytes = $bytesHeader + $bytesContent + $bytesFooter
 
        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $result = Invoke-WebRequest -Method Post -Uri "http://$($d)/edit" -Body $bytes -Headers @{ "Content-Length"= $bytes.Count } -ContentType "multipart/form-data; boundary=$($Boundary)" -UseBasicParsing -Verbose:$false

            if($PassThru) { $result }
        }
    }

    End {
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Item\Set-AwtrixItemContent.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Settings\$AwtrixSettings.ps1

$Script:AwtrixSettingsApi = [ordered]@{
    #                                                                                       # ? tested ok 
    #                                                                                       # ? tested doesn't work
    #                                                                                       # ? not tested or unknown how this should work
                                                                                            
    #                                                                                       #    ParameterName               # Key         Type                 Description                                                                        ValueRange                          Default
    #                                                                                       #    --------------------------- # ---         ----                 -----------                                                                        ----------                          -------
    AppDisplayDuration          = @("ATIME      ", {                               $args }) # ? AppDisplayDuration          # ATIME       number               Duration an app is displayed in seconds.                                           Positive integer                    7      
    TransitionEffect            = @("TEFF       ", { ConvertTo-Awtrix -Transition  $args }) # ? TransitionEffect            # TEFF        number               Choose between app transition effects.                                             0-10                                1      
    TransitionTime              = @("TSPEED     ", {                               $args }) # ? TransitionTime              # TSPEED      number               Time taken for the transition to the next app in milliseconds.                     Positive integer                    500    
    AutoTransition              = @("ATRANS     ", { ConvertTo-Awtrix -Bool        $args }) # ? AutoTransition              # ATRANS      boolean              Automatic switching to the next app.                                               true/false                          N/A    
                                                                        
    TextColor                   = @("TCOL       ", { ConvertTo-Awtrix -Color       $args }) # ? TextColor                   # TCOL        string/array of ints Global text color.                                                                 RGB array or hex color              N/A    
    TextCase                    = @("UPPERCASE  ", { ConvertTo-Awtrix -UpperCase   $args }) # ? Uppercase                   # UPPERCASE   boolean              Display text in uppercase.                                                         true/false                          true   
                                                                        
    StartOfWeek                 = @("SOM        ", { ConvertTo-Awtrix -StartOfWeek $args }) # ? StartOfWeek                 # SOM         boolean              Start the week on Monday.                                                          true/false                          true   
                                                                        
    TimeAppEnable               = @("TIM        ", { ConvertTo-Awtrix -Bool        $args }) # ? TimeAppEnable               # TIM         boolean              Enable or disable the native time app (requires reboot).                           true/false                          true   
    TimeAppStyle                = @("TMODE      ", {                               $args }) # ? TimeAppStyle                # TMODE       integer              Changes the time app style.                                                        0-4                                 1      
    TimeAppFormat               = @("TFORMAT    ", {                               $args }) # ? TimeAppFormat               # TFORMAT     string               Time format for the TimeApp.                                                       Varies (see documentation)          N/A    
                                                                        
    TimeAppColorText            = @("TIME_COL   ", { ConvertTo-Awtrix -Color       $args }) # ? TimeAppColorText            # TIME_COL    string/array of ints Text color of the time app. Use 0 for global text color.                           RGB array or hex color              N/A    
    TimeAppColorCalenderHeader  = @("CHCOL      ", { ConvertTo-Awtrix -Color       $args }) # ? TimeAppColorCalenderHeader  # CHCOL       string/array of ints Calendar header color of the time app.                                             RGB array or hex color              #FF0000
    TimeAppColorCalenderBody    = @("CBCOL      ", { ConvertTo-Awtrix -Color       $args }) # ? TimeAppColorCalenderBody    # CBCOL       string/array of ints Calendar body color of the time app.                                               RGB array or hex color              #FFFFFF
    TimeAppColorCalenderText    = @("CTCOL      ", { ConvertTo-Awtrix -Color       $args }) # ? TimeAppColorCalenderText    # CTCOL       string/array of ints Calendar text color in the time app.                                               RGB array or hex color              #000000
                                                                        
    TimeAppColorActiveWeekDay   = @("WDCA       ", { ConvertTo-Awtrix -Color       $args }) # ? TimeAppColorActiveWeekDay   # WDCA        string/array of ints Active weekday color.                                                              RGB array or hex color              N/A    
    TimeAppColorInActiveWeekDay = @("WDCI       ", { ConvertTo-Awtrix -Color       $args }) # ? TimeAppColorInActiveWeekDay # WDCI        string/array of ints Inactive weekday color.                                                            RGB array or hex color              N/A    
                                                                        
    TimeAppDisplayWeekday       = @("WD         ", { ConvertTo-Awtrix -Bool        $args }) # ? TimeAppColorDisplayWeekday  # WD          boolean              Enable or disable the weekday display.                                             true/false                          true   
                                                                        
    DateAppEnable               = @("DAT        ", { ConvertTo-Awtrix -Bool        $args }) # ? DateAppEnable               # DAT         boolean              Enable or disable the native date app (requires reboot).                           true/false                          true   
    DateAppFormat               = @("DFORMAT    ", {                               $args }) # ? DateAppFormat               # DFORMAT     string               Date format for the DateApp.                                                       Varies (see documentation)          N/A    
    DateAppColorText            = @("DATE_COL   ", { ConvertTo-Awtrix -Color       $args }) # ? DateAppColorText            # DATE_COL    string/array of ints Text color of the date app. Use 0 for global text color.                           RGB array or hex color              N/A    
                                                                        
    TempratureAppEnable         = @("TEMP       ", { ConvertTo-Awtrix -Bool        $args }) # ? TempratureAppEnable         # TEMP        boolean              Enable or disable the native temperature app (requires reboot).                    true/false                          true   
    TempratureAppColorText      = @("TEMP_COL   ", { ConvertTo-Awtrix -Color       $args }) # ? TempratureAppColorText      # TEMP_COL    string/array of ints Text color of the temperature app. Use 0 for global text color.                    RGB array or hex color              N/A    
                                                                        
    HumidityAppEnable           = @("HUM        ", { ConvertTo-Awtrix -Bool        $args }) # ? HumidityAppEnable           # HUM         boolean              Enable or disable the native humidity app (requires reboot).                       true/false                          true   
    HumidityAppColorText        = @("HUM_COL    ", { ConvertTo-Awtrix -Color       $args }) # ? HumidityAppColorText        # HUM_COL     string/array of ints Text color of the humidity app. Use 0 for global text color.                       RGB array or hex color              N/A    
                                                                        
    BatteryAppEnable            = @("BAT        ", { ConvertTo-Awtrix -Bool        $args }) # ? BatteryAppEnable            # BAT         boolean              Enable or disable the native battery app (requires reboot).                        true/false                          true   
    BatteryAppColorText         = @("BAT_COL    ", { ConvertTo-Awtrix -Color       $args }) # ? BatteryAppColorText         # BAT_COL     string/array of ints Text color of the battery app. Use 0 for global text color.                        RGB array or hex color              N/A    
                                                                        
    Brightness                  = @("BRI        ", {                               $args }) # ? Brightness                  # BRI         number               Matrix brightness.                                                                 0-255                               N/A    
    AutoBrightness              = @("ABRI       ", { ConvertTo-Awtrix -Bool        $args }) # ? AutoBrightness              # ABRI        boolean              Automatic brightness control.                                                      true/false                          N/A    
                                                                        
    ColorCorrection             = @("CCORRECTION", { ConvertTo-Awtrix -Color       $args }) # ? ColorCorrection             # CCORRECTION array of ints        Color correction for the matrix.                                                   RGB array                           N/A    
    ColorTemperature            = @("CTEMP      ", { ConvertTo-Awtrix -Color       $args }) # ? ColorTemperature            # CTEMP       array of ints        Color temperature for the matrix.                                                  RGB array                           N/A    
                                                                        
    GammaCorrection             = @("GAMMA      ", {                               $args }) # ? GammaCorrection             # GAMMA       float                currently not documented
                                                                                    
    ScrollSpeedPercent          = @("SSPEED     ", {                               $args }) # ? ScrollSpeedPercent          # SSPEED      integer              Scroll speed modification.                                                         Percentage of original scroll speed 100    
                                                                        
    BlockPhysicalKeys           = @("BLOCKN     ", { ConvertTo-Awtrix -Bool        $args }) # ? BlockPhysicalKeys           # BLOCKN      boolean              Block physical navigation keys (still sends input to MQTT).                        true/false                          false  
                                                                        
    MatrixEnabled               = @("MATP       ", { ConvertTo-Awtrix -Bool        $args }) # ? MatrixEnabled               # MATP        boolean              Enable or disable the matrix. Similar to power Endpoint but without the animation. true/false                          true   

    Volume                      = @("VOL        ", {                               $args }) # ? Volume                      # VOL         integer              Allows to set the Volume of the Buzzer and DFplayer                                0-30                                true

    OverlayEffect               = @("OVERLAY    ", {                               $args }) # ? OverlayEffect               # OVERLAY     string               Sets a global effect overlay (cannot be used with app specific overlays)           Varies (see below)                  N/A
                                                                        
    CEL                         = @("CEL        ", { ConvertTo-Awtrix -Bool        $args }) # ? CEL                         # CEL         boolean              currently not documented
    MAT                         = @("MAT        ", {                               $args }) # ? MAT                         # MAT         integer              currently not documented
    SOUND                       = @("SOUND      ", { ConvertTo-Awtrix -Bool        $args }) # ? SOUND                       # SOUND       boolean              currently not documented
}

$Script:AwtrixSettingsApiRaw2PS = [ordered]@{}

foreach($kv in $Script:AwtrixSettingsApi.GetEnumerator())
{
    $Script:AwtrixSettingsApiRaw2PS[$kv.Value[0].Trim()] = $kv.Key
}

$Script:AwtrixSettingsApi += [ordered]@{

    Power                       = @("power      ", { ConvertTo-Awtrix -OnOff       $args })
                                                                                  
    On                          = @("power      ", { ConvertTo-Awtrix -Bool        $args })
    Off                         = @("power      ", { ConvertTo-Awtrix -BoolNot     $args })
                                                                                  
    Sleep                       = @("sleep      ", {                               $args })
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Settings\$AwtrixSettings.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Settings\Get-Awtrix.ps1

function Get-Awtrix
{
    [CmdletBinding()]
    param(
                                                   [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),                                           

        [Parameter(ParameterSetName='Effects'    )][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Effects,
        [Parameter(ParameterSetName='Transitions')][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Transitions,

        [Parameter(ParameterSetName='Statistics' )][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Statistics,
        [Parameter(ParameterSetName='Settings'   )][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Settings,
        [Parameter(ParameterSetName='Apps'       )][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Apps,
        [Parameter(ParameterSetName='Screen'     )][Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Screen,

        [Parameter(ParameterSetName='Screen'     )][Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Char,
                                                                                                                          
        [Parameter(ParameterSetName='Statistics' )]
        [Parameter(ParameterSetName='Settings'   )]
        [Parameter(ParameterSetName='Apps'       )]
        [Parameter(ParameterSetName='Screen'     )]
                                                   [Parameter(ValueFromPipelineByPropertyName)]                  [switch  ]$Raw
    )

    Begin {

        $api = @{

            Settings    = 'settings'
            Statistics  = 'stats'
            Effects     = 'effects'
            Transitions = 'transitions'
            Apps        = 'loop'
            Screen      = 'screen'
        }

        # [PSCustomObject]@{ Device = $d; Data = $result } | Select-Object -ExpandProperty Data -Property xxNamexx| Select-Object -Property @{ Name = 'Device'; Expression = { $_.xxNamexx } }, * -ExcludeProperty xxNamexx
        #                                        $result   | Select-Object -Property @{ Name = 'Device'; Expression = { $d } }, *
    }

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $result = Invoke-RestMethod -Method Get -Uri "http://$($d)/api/$($api[$PSCmdlet.ParameterSetName])" -Verbose:$false

            switch($PSCmdlet.ParameterSetName)
            {
                Effects     { [PSCustomObject]@{ Device = $d; Effects     = $result } }
                Transitions { [PSCustomObject]@{ Device = $d; Transitions = $result } }

                Statistics {
                
                    if($Raw.IsPresent)
                    {
                        $result | Select-Object -Property @{ Name = 'Device'; Expression = { $d } }, *
                    }
                    else
                    {
                        $result | Select-Object -Property @{ Name = 'Device'; Expression = { $d } }, *
                    }
                }

                Settings {
                
                    if($Raw.IsPresent)
                    {
                        $result | Select-Object -Property @{ Name = 'Device'; Expression = { $d } }, *
                    }
                    else
                    {
                        $dict = [ordered]@{ Device = $d }

                        foreach($property in $AwtrixSettingsApiRaw2PS.Keys)
                        {
                            $dict[$AwtrixSettingsApiRaw2PS[$property]] = $result.$property
                        }

                        [PSCustomObject]$dict
                    }
                }

                Apps {
                
                    if($Raw.IsPresent)
                    {
                        [PSCustomObject]@{ Device = $d; Apps = $result }
                    }
                    else
                    {
                        [PSCustomObject]@{ Device = $d; Apps = ($result | Get-Member -MemberType NoteProperty | Select-Object Name, @{ Name = 'Index'; Expression = { $_.Definition.Split('=')[-1] } } | Sort-Object Index).Name }
                    }
                }

                Screen {
                
                    if($Raw.IsPresent)
                    {
                        [PSCustomObject]@{ Device = $d; Screen = $result }
                    }
                    else
                    { 
                        $char = switch($char.Length)
                        {
                            0       { " ¦"     }
                            1       { " $Char" }
                            default {   $Char  }
                        }

                        $view = @()
                        $Line =  ''

                        foreach($pixel in $result)
                        {
                            if($Line.Length -lt 32)
                            {
                                $Line += . { if($pixel -eq 0) { $char[0] } else { $char[1] } }
                            }

                            if($Line.Length -eq 32)
                            {
                                $view += $Line
                                $Line  =  ''
                            }
                        }

                        [PSCustomObject]@{ Device = $d; Screen = $view }
                    }
                }
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Settings\Get-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\_Settings\Set-Awtrix.ps1

function Set-Awtrix
{
    [CmdletBinding()]
    param(
                                             [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                                     [string[]]$Device = (Get-AwtrixGlobal -Devices),
                                                                                                                                                
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [uint32  ]$AppDisplayDuration         , # ATIME       number               Duration an app is displayed in seconds.                                           Positive integer                    7      
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Transition  @args})][string  ]$TransitionEffect           , # TEFF        number               Choose between app transition effects.                                             0-10                                1      
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [uint32  ]$TransitionTime             , # TSPEED      number               Time taken for the transition to the next app in milliseconds.                     Positive integer                    500    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$AutoTransition             , # ATRANS      boolean              Automatic switching to the next app.                                               true/false                          N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TextColor                  , # TCOL        string/array of ints Global text color.                                                                 RGB array or hex color              N/A    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -UpperCase   @args})][string  ]$TextCase                   , # UPPERCASE   boolean              Display text in uppercase.                                                         true/false                          true   
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -StartOfWeek @args})][string  ]$StartOfWeek                , # SOM         boolean              Start the week on Monday.                                                          true/false                          true   
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$TimeAppEnable              , # TIM         boolean              Enable or disable the native time app (requires reboot).                           true/false                          true   
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ValidateRange(0,4)]                                   [uint32  ]$TimeAppStyle               , # TMODE       integer              Changes the time app style.                                                        0-4                                 1      
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -TimeFormat  @args})][string  ]$TimeAppFormat              , # TFORMAT     string               Time format for the TimeApp.                                                       Varies (see documentation)          N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TimeAppColorText           , # TIME_COL    string/array of ints Text color of the time app. Use 0 for global text color.                           RGB array or hex color              N/A    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TimeAppColorCalenderHeader , # CHCOL       string/array of ints Calendar header color of the time app.                                             RGB array or hex color              #FF0000
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TimeAppColorCalenderBody   , # CBCOL       string/array of ints Calendar body color of the time app.                                               RGB array or hex color              #FFFFFF
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TimeAppColorCalenderText   , # CTCOL       string/array of ints Calendar text color in the time app.                                               RGB array or hex color              #000000
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TimeAppColorActiveWeekDay  , # WDCA        string/array of ints Active weekday color.                                                              RGB array or hex color              N/A    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TimeAppColorInActiveWeekDay, # WDCI        string/array of ints Inactive weekday color.                                                            RGB array or hex color              N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$TimeAppDisplayWeekday      , # WD          boolean              Enable or disable the weekday display.                                             true/false                          true   
                                                                                                                                                
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$DateAppEnable              , # DAT         boolean              Enable or disable the native date app (requires reboot).                           true/false                          true   
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -DateFormat  @args})][string  ]$DateAppFormat              , # DFORMAT     string               Date format for the DateApp.                                                       Varies (see documentation)          N/A    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$DateAppColorText           , # DATE_COL    string/array of ints Text color of the date app. Use 0 for global text color.                           RGB array or hex color              N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$TempratureAppEnable        , # TEMP        boolean              Enable or disable the native temperature app (requires reboot).                    true/false                          true   
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$TempratureAppColorText     , # TEMP_COL    string/array of ints Text color of the temperature app. Use 0 for global text color.                    RGB array or hex color              N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$HumidityAppEnable          , # HUM         boolean              Enable or disable the native humidity app (requires reboot).                       true/false                          true   
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$HumidityAppColorText       , # HUM_COL     string/array of ints Text color of the humidity app. Use 0 for global text color.                       RGB array or hex color              N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$BatteryAppEnable           , # BAT         boolean              Enable or disable the native battery app (requires reboot).                        true/false                          true   
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$BatteryAppColorText        , # BAT_COL     string/array of ints Text color of the battery app. Use 0 for global text color.                        RGB array or hex color              N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ValidateRange(0,255)]                                 [uint32  ]$Brightness                 , # BRI         number               Matrix brightness.                                                                 0-255                               N/A    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$AutoBrightness             , # ABRI        boolean              Automatic brightness control.                                                      true/false                          N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$ColorCorrection            , # CCORRECTION array of ints        Color correction for the matrix.                                                   RGB array                           N/A    
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color       @args})][object[]]$ColorTemperature           , # CTEMP       array of ints        Color temperature for the matrix.                                                  RGB array                           N/A    
                                                                                                                                             
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [float   ]$GammaCorrection            , # GAMMA       float                currently not documented
                                                                                                                                                
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)][ValidateRange(0,100)]                                 [uint32  ]$ScrollSpeedPercent         , # SSPEED      integer              Scroll speed modification.                                                         Percentage of original scroll speed 100    
                                                                                                                                                
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$BlockPhysicalKeys          , # BLOCKN      boolean              Block physical navigation keys (still sends input to MQTT).                        true/false                          false  
                                                                                                                                                
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$MatrixEnabled              , # MATP        boolean              Enable or disable the matrix. Similar to power Endpoint but without the animation. true/false                          true   
                                                                                                                                                
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$CEL                        , # CEL         boolean              currently not documented
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [uint32  ]$MAT                        , # MAT         integer              currently not documented
        [Parameter(ParameterSetName='Set'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$SOUND                      , # SOUND       boolean              currently not documented
                                                                                                                                             
        [Parameter(ParameterSetName='Pwr'  )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -OnOff       @args})][string  ]$Power,
                                                                                                                                             
        [Parameter(ParameterSetName='On'   )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$On,
                                                                                                                                             
        [Parameter(ParameterSetName='Off'  )][Parameter(ValueFromPipelineByPropertyName)]                                                       [switch  ]$Off,
                                                                                                                                             
        [Parameter(ParameterSetName='Sleep')][Parameter(ValueFromPipelineByPropertyName)]                                                       [uint32  ]$Sleep
    )

    Begin {

        $api = @{

            Set   = 'settings'
            Pwr   = 'power'
            On    = 'power'
            Off   = 'power'
            Sleep = 'sleep'
        }
    }

    Process {
    
        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $Body = New-AwtrixApiBody -Api $AwtrixSettingsApi -BoundParameters $PSBoundParameters

            Write-Verbose ($Body | ConvertTo-Json)

            $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/$($api[$PSCmdlet.ParameterSetName])" -Body ($Body | ConvertTo-Json -Compress) -ContentType "application/json" -Verbose:$false

            if('OK' -ne $result) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\_Settings\Set-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Clear-Awtrix.ps1

function Clear-Awtrix
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices)
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/notify/dismiss" -Verbose:$false

            if('OK' -ne $result) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Clear-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Convert\Convert-AwtrixValue.ps1

function Convert-AwtrixValue
{
    [CmdletBinding(DefaultParameterSetName='PS2Awtrix')]
    param(
        [Parameter(ParameterSetName='PS2Awtrix')]
        [Parameter(ParameterSetName='Awtrix2PS')][Parameter(ValueFromPipelineByPropertyName,Position=1)][ArgumentCompleter({Get-AwtrixArg -ConverterName  @args})][string]$Name,

        [Parameter(ParameterSetName='PS2Awtrix')]
        [Parameter(ParameterSetName='Awtrix2PS')][Parameter(ValueFromPipelineByPropertyName,Position=2)][ArgumentCompleter({Get-AwtrixArg -ConverterValue @args})]        $Value,

        [Parameter(ParameterSetName='PS2Awtrix')][Parameter(ValueFromPipelineByPropertyName)]                                                                     [switch]$PS2Awtrix,
        [Parameter(ParameterSetName='Awtrix2PS')][Parameter(ValueFromPipelineByPropertyName)]                                                                     [switch]$Awtrix2PS
    )

    if($PSBoundParameters.ContainsKey('Value'))
    {
        ($Script:AwtrixValueConverter[$Name]."$($PSCmdlet.ParameterSetName)")[$Value]
    }
    else
    {
        switch($PSCmdlet.ParameterSetName)
        {
            'PS2Awtrix' { ($Script:AwtrixValueConverter[$Name]."$($PSCmdlet.ParameterSetName)").GetEnumerator() | Where-Object Name  -ne '' }
            'Awtrix2PS' { ($Script:AwtrixValueConverter[$Name]."$($PSCmdlet.ParameterSetName)").GetEnumerator() | Where-Object Value -ne '' }
        }
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Convert\Convert-AwtrixValue.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Convert\ConvertFrom-Awtrix.ps1

function ConvertFrom-Awtrix
{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ParameterSetName='App'        )][switch  ]$App,
        [Parameter(Position=0,ParameterSetName='Indicator'  )][switch  ]$Indicator,
        [Parameter(Position=0,ParameterSetName='UpperCase'  )][switch  ]$UpperCase,
        [Parameter(Position=0,ParameterSetName='TextCase'   )][switch  ]$TextCase,
        [Parameter(Position=0,ParameterSetName='Color'      )][switch  ]$Color,

        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$Effect,
        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$Timeformat,
        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$Dateformat,

        [Parameter(Position=0,ParameterSetName='Transition' )][switch  ]$Transition,
        [Parameter(Position=0,ParameterSetName='StartOfWeek')][switch  ]$StartOfWeek,
        [Parameter(Position=0,ParameterSetName='OnOff'      )][switch  ]$OnOff,
        [Parameter(Position=0,ParameterSetName='MoveIcon'   )][switch  ]$MoveIcon,
        [Parameter(Position=0,ParameterSetName='LifeMode'   )][switch  ]$LifeMode,

        [Parameter(Position=0,ParameterSetName='Bool'       )][switch  ]$Bool,
        [Parameter(Position=0,ParameterSetName='BoolNot'    )][switch  ]$BoolNot,

        [Parameter(Position=0,ParameterSetName='Clients'    )][switch  ]$Clients,

        [Parameter(Position=0,ParameterSetName='Json'       )][switch  ]$Json,

        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$PassThru,

        [Parameter(Position=1)]                                         $Value
    )
    
    switch($PSCmdlet.ParameterSetName)
    {
        PassThru { $Value }

        Color    { $Value }

        Bool     {      ([bool]($Value[0])) }
        BoolNot  { -not ([bool]($Value[0])) }

        Clients  { if($Value[0] -eq '*') { @($null, (Get-AwtrixGlobal -Clients)) } else { @($null, $Value) } }

        Json     { $Value | ConvertFrom-Json }

        default  { $Script:AwtrixValueConverter[$PSCmdlet.ParameterSetName].Awtrix2PS[$Value] }
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Convert\ConvertFrom-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Convert\ConvertTo-Awtrix.ps1

function ConvertTo-Awtrix
{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ParameterSetName='App'        )][switch  ]$App,
        [Parameter(Position=0,ParameterSetName='Indicator'  )][switch  ]$Indicator,
        [Parameter(Position=0,ParameterSetName='UpperCase'  )][switch  ]$UpperCase,
        [Parameter(Position=0,ParameterSetName='TextCase'   )][switch  ]$TextCase,
        [Parameter(Position=0,ParameterSetName='Color'      )][switch  ]$Color,

        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$Effect,
        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$Timeformat,
        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$Dateformat,

        [Parameter(Position=0,ParameterSetName='Transition' )][switch  ]$Transition,
        [Parameter(Position=0,ParameterSetName='StartOfWeek')][switch  ]$StartOfWeek,
        [Parameter(Position=0,ParameterSetName='OnOff'      )][switch  ]$OnOff,
        [Parameter(Position=0,ParameterSetName='MoveIcon'   )][switch  ]$MoveIcon,
        [Parameter(Position=0,ParameterSetName='LifeMode'   )][switch  ]$LifeMode,

        [Parameter(Position=0,ParameterSetName='Bool'       )][switch  ]$Bool,
        [Parameter(Position=0,ParameterSetName='BoolNot'    )][switch  ]$BoolNot,

        [Parameter(Position=0,ParameterSetName='Clients'    )][switch  ]$Clients,

        [Parameter(Position=0,ParameterSetName='Json'       )][switch  ]$Json,

        [Parameter(Position=0,ParameterSetName='PassThru'   )][switch  ]$PassThru,

        [Parameter(Position=1)]                                         $Value
    )

    switch($PSCmdlet.ParameterSetName)
    {
        PassThru { $Value }

        Color    { ConvertTo-AwtrixColor $Value }

        Bool     {      ([bool]($Value[0])) }
        BoolNot  { -not ([bool]($Value[0])) }

        Clients  { if($Value[0] -eq '*') { @($null, (Get-AwtrixGlobal -Clients)) } else { @($null, $Value) } }

        Json     { $Value | ConvertTo-Json -Compress }

        default  { $Script:AwtrixValueConverter[$PSCmdlet.ParameterSetName].PS2Awtrix[$Value] }
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Convert\ConvertTo-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Convert\ConvertTo-AwtrixColor.ps1

function ConvertTo-AwtrixColor
{
    [CmdletBinding()]
    Param(
        [Parameter()][object[]]$Value
    )

    $r, $g, $b = $Value

    switch($Value.Length)
    {
        1 { # exactly one 6-digit hex value (prefix "0x" or "#" allowed)

            if($r -is [string])
            {
                if($r -match "^(0x|#){0,1}([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$") # exactly one 6-digit hex value (prefix "0x" or "#" allowed), eg. 0x012def or #456abc or 789abc
                {
                    $c = [System.Drawing.Color]::FromArgb([byte]"0x$($Matches[2])", [byte]"0x$($Matches[3])", [byte]"0x$($Matches[4])")
                }
                else
                {
                    $c = [System.Drawing.Color]::FromName($r)

                    if(-not $c.IsKnownColor) { $c = $null }
                }
            }
        }

        3 { # three 2-digit hex values (prefix "0x" and "#" allowed) or three integer values, each between 0 and 255 (incl.)

            if(($r -is [string]) -and ($g -is [string]) -and ($b -is [string])) # three 2-digit hex values (prefix "0x" and "#" allowed)
            {
                if($r -match "^(0x|#){0,1}([0-9a-f]{2})$") { $r = [byte]"0x$($Matches[2])" } else { break }
                if($g -match "^(0x|#){0,1}([0-9a-f]{2})$") { $g = [byte]"0x$($Matches[2])" } else { break }
                if($b -match "^(0x|#){0,1}([0-9a-f]{2})$") { $b = [byte]"0x$($Matches[2])" } else { break }

                $c = [System.Drawing.Color]::FromArgb($r, $g, $b)
            }
            elseif(($r -is [int32]) -and ($g -is [int32]) -and ($b -is [int32])) # three integer values, each between 0 and 255 (incl.)
            {
                if((0 -le $r) -and ($r -le 255)) { } else { break }
                if((0 -le $g) -and ($g -le 255)) { } else { break }
                if((0 -le $b) -and ($b -le 255)) { } else { break }

                $c = [System.Drawing.Color]::FromArgb($r, $g, $b)
            }
        }

        default {}
    }

    if($c)
    {
        "$(($c.R).ToString("x2"))$(($c.G).ToString("x2"))$(($c.B).ToString("x2"))"
    }
    else
    {
        throw [System.Exception]::new("Unknown color $($Value -join ',')")
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Convert\ConvertTo-AwtrixColor.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Convert\Get-AwtrixArg.ps1

[void]{

    Start-Process "microsoft-edge:https://learn.microsoft.com/de-de/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-5.1"

    Start-Process "microsoft-edge:https://adamtheautomator.com/powershell-validatescript/"
}

function Get-AwtrixArg
{
    Param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters,
                                                                 
        [switch  ]$App,           # [Parameter(ParameterSetName='App'           )]
        [switch  ]$Indicator,     # [Parameter(ParameterSetName='Indicator'     )]
        [switch  ]$UpperCase,     # [Parameter(ParameterSetName='UpperCase'     )]
        [switch  ]$TextCase,      # [Parameter(ParameterSetName='TextCase'      )]
        [switch  ]$Color,         # [Parameter(ParameterSetName='Color'         )]
        [switch  ]$Effect,        # [Parameter(ParameterSetName='Effect'        )]
        [switch  ]$Palette,       # [Parameter(ParameterSetName='Palette'       )]
        [switch  ]$TimeFormat,    # [Parameter(ParameterSetName='TimeFormat'    )]
        [switch  ]$DateFormat,    # [Parameter(ParameterSetName='DateFormat'    )]
        [switch  ]$Transition,    # [Parameter(ParameterSetName='Transition'    )]
        [switch  ]$StartOfWeek,   # [Parameter(ParameterSetName='StartOfWeek'   )]
        [switch  ]$OnOff,         # [Parameter(ParameterSetName='OnOff'         )]
        [switch  ]$MoveIcon,      # [Parameter(ParameterSetName='MoveIcon'      )]
        [switch  ]$LifeMode,      # [Parameter(ParameterSetName='LifeMode'      )]
        [switch  ]$ConverterName, # [Parameter(ParameterSetName='ConverterName' )]
        [switch  ]$ConverterValue # [Parameter(ParameterSetName='ConverterValue')]
                                                            
       #[switch  ]$Bool,          # [Parameter(ParameterSetName='Bool'          )]
       #[switch  ]$Not,           # [Parameter(ParameterSetName='Bool'          )]

       #[switch  ]$Json           # [Parameter(ParameterSetName='JSon'          )]
    )

    #Write-Host $PSCmdlet.ParameterSetName -ForegroundColor Green

    #$AwtrixValueConverter[$PSCmdlet.ParameterSetName].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") })

    # Write-Host ($fakeBoundParameters | ConvertTo-Json)

    switch($true)
    {
        $App            { $Script:AwtrixValueConverter['App'        ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $Indicator      { $Script:AwtrixValueConverter['Indicator'  ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $UpperCase      { $Script:AwtrixValueConverter['UpperCase'  ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $TextCase       { $Script:AwtrixValueConverter['TextCase'   ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $Color          { $Script:AwtrixValueConverter['Color'      ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $Effect         { $Script:AwtrixValueConverter['Effect'     ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $Palette        { $Script:AwtrixValueConverter['Palette'    ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $TimeFormat     { $Script:AwtrixValueConverter['TimeFormat' ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $DateFormat     { $Script:AwtrixValueConverter['DateFormat' ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $Transition     { $Script:AwtrixValueConverter['Transition' ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $StartOfWeek    { $Script:AwtrixValueConverter['StartOfWeek'].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $OnOff          { $Script:AwtrixValueConverter['OnOff'      ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $MoveIcon       { $Script:AwtrixValueConverter['MoveIcon'   ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }
        $LifeMode       { $Script:AwtrixValueConverter['LifeMode'   ].PS2Awtrix.Keys.Where({ -not [string]::IsNullOrWhiteSpace("$_") }) }

        $ConverterName  { $Script:AwtrixValueConverterNames } 

        $ConverterValue {

            if($fakeBoundParameters.Name)
            {
                if($fakeBoundParameters.Awtrix2PS -eq $Transition)
                {
                    $Script:AwtrixValueConverter[$fakeBoundParameters.Name].Awtrix2PS.Keys -ne ''
                }
                else
                {
                    $Script:AwtrixValueConverter[$fakeBoundParameters.Name].PS2Awtrix.Keys -ne ''
                }
            }
        } 
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Convert\Get-AwtrixArg.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Convert\New-AwtrixValueConverter.ps1

$Script:AwtrixValueConverter = [ordered]@{}

$Script:AwtrixValueConverterNames = @()

function New-AwtrixValueConverter([string]$Name, [Switch]$Indexed, $Data)
{
    $Script:AwtrixValueConverterNames += $Name

    $Script:AwtrixValueConverter[$Name] = [PSCustomObject]@{

        PS2Awtrix = [ordered]@{}
        Awtrix2PS = [ordered]@{}
    }

    if($Data -is [System.Collections.IDictionary])
    {
        foreach($item in $Data.GetEnumerator())
        {
            $Script:AwtrixValueConverter[$Name].PS2Awtrix.Add($item.Key  , $item.Value)
            $Script:AwtrixValueConverter[$Name].Awtrix2PS.Add($item.Value, $item.Key  )
        }
    }
    elseif(($data | Select-Object -First 1).GetType().Name -like 'KeyValuePair*')
    {
        foreach($item in $Data)
        {
            $Script:AwtrixValueConverter[$Name].PS2Awtrix[$item.Key  ] = $item.Value
            $Script:AwtrixValueConverter[$Name].Awtrix2PS[$item.Value] = $item.Key
        }
    }
    elseif($Data -is [Array])
    {
        $Indexed = . { if(-not $PSBoundParameters.ContainsKey("Indexed")) { $true } else { $Indexed.IsPresent } }

        if($Indexed)
        {
            for($zz = 0; $zz -lt $Data.Count; $zz++)
            {
                $Script:AwtrixValueConverter[$Name].PS2Awtrix.Add($Data[$zz],       $zz )
                $Script:AwtrixValueConverter[$Name].Awtrix2PS.Add(      $zz , $Data[$zz])
            }
        }
        else
        {
            foreach($item in $Data)
            {
                $Script:AwtrixValueConverter[$Name].PS2Awtrix.Add($item, $item)
                $Script:AwtrixValueConverter[$Name].Awtrix2PS.Add($item, $item)
            }
        }
    }
    elseif($Data -is [string])
    {
        $items = $Data.Split([char[]]@(0x0a, 0x0d), [System.StringSplitOptions]::RemoveEmptyEntries).ForEach({$_.Split('#')[0].Trim()})

        if($Indexed)
        {
            for($zz = 0; $zz -lt $items.Count; $zz++)
            {
                $Script:AwtrixValueConverter[$Name].PS2Awtrix.add($items[$zz],        $zz )
                $Script:AwtrixValueConverter[$Name].Awtrix2PS.add(       $zz , $items[$zz])
            }
        }
        else
        {
            foreach($item in $items)
            {
                $Script:AwtrixValueConverter[$Name].PS2Awtrix.Add($item, $item)
                $Script:AwtrixValueConverter[$Name].Awtrix2PS.Add($item, $item)
            }
        }
    }
}

#region New-AwtrixValueConverter ...

New-AwtrixValueConverter -Name App -Data ([ordered]@{

    Time        = 'TIM'
    Date        = 'DAT'
    Temperature = 'TEMP'
    Humidity    = 'HUM'
    Battery     = 'BAT'
})

New-AwtrixValueConverter -Name Indicator -Data (@(

    ""
    "UpperRight"
    "RightSide"
    "LowerRight"
))

New-AwtrixValueConverter -Name UpperCase -Data ([ordered]@{

    AsIs  = $false
    Upper = $true
})

New-AwtrixValueConverter -Name TextCase -Indexed -Data @"

    Default
    Upper
    AsIs
"@

New-AwtrixValueConverter -Name Color -Indexed:$false -Data (([System.Drawing.Color] | Get-Member -Static -MemberType Property | Where-Object Definition -like "System.Drawing.Color *").Name)

New-AwtrixValueConverter -Name ColorMap -Data (. {
<#
    00FFFF Aqua        Cyan        
    FF00FF Fuchsia     Magenta     
    FFFFFF Transparent White       
#>
    foreach($Name in (([System.Drawing.Color] | Get-Member -Static -MemberType Property | Where-Object Definition -like "System.Drawing.Color *").Name))
    {
        $Color = [System.Drawing.Color]::FromName($Name)

        if($Color.IsKnownColor)
        {
            [System.Collections.Generic.KeyValuePair[string,string]]::new($Color.Name, "$($Color.R.ToString("X2"))$($Color.G.ToString("X2"))$($Color.B.ToString("X2"))")
        }
    }
})

New-AwtrixValueConverter -Name Effect -Indexed:$false -Data (Get-AwtrixEffectSettings -List)

New-AwtrixValueConverter -Name Palette -Data @"

    Cloud
    Lava
    Ocean
    Forest
    Stripe
    Party
    Heat
    Rainbow
"@

New-AwtrixValueConverter -Name TimeFormat -Data @"

    %H:%M:%S   # 13:30:45  
    %l:%M:%S   # 1:30:45  
    %H:%M      # 13:30  
    %H %M      # 13:30 with blinking colon  
    %l:%M      # 1:30  
    %l %M      # 1:30 with blinking colon  
    %l:%M %p   # 1:30 PM  
    %l %M %p   # 1:30 PM with blinking colon  
"@

New-AwtrixValueConverter -Name DateFormat -Data @"

    %d.%m.%y   # 16.04.22  
    %d.%m      # 16.04  
    %y-%m-%d   # 22-04-16  
    %m-%d      # 04-16  
    %m/%d/%y   # 04/16/22  
    %m/%d      # 04/16  
    %d/%m/%y   # 16/04/22  
    %d/%m      # 16/04  
    %m-%d-%y   # 04-16-22  
"@

New-AwtrixValueConverter -Name Transition -Indexed -Data @"

    Random
    Slide
    Dim
    Zoom
    Rotate
    Pixelate
    Curtain
    Ripple
    Blink
    Reload
    Fade 
"@

New-AwtrixValueConverter -Name StartOfWeek -Data ([ordered]@{

    Sunday = $false
    Monday = $true
})

New-AwtrixValueConverter -Name OnOff -Data ([ordered]@{

    Off = $false
    On  = $true
})

New-AwtrixValueConverter -Name MoveIcon -Indexed -Data @"

    DontMove  # 0 = Icon doesn't move
    MoveOnce  # 1 = Icon moves with text and will not appear again.
    Repeat    # 2 = Icon moves with text but appears again when the text starts to scroll again. 
"@

New-AwtrixValueConverter -Name LifeMode -Indexed -Data @"

    Remove
    MarkAsStaled
"@

New-AwtrixValueConverter -Name OverlayEffect -Data @"
    clear
    snow
    rain
    drizzle
    storm
    thunder
    frost
"@

#endregion

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Convert\New-AwtrixValueConverter.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Debug\Debug-AwtrixNotifyApi.ps1

function Debug-AwtrixNotifyApi([switch]$Raw2PS)
{
    @(
        $Script:AwtrixNotifyApi
        $Script:AwtrixNotifyApiRaw2PS

    )[$Raw2PS.IsPresent]
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Debug\Debug-AwtrixNotifyApi.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Debug\Debug-AwtrixParameter.ps1

function Debug-AwtrixParameter
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string[]]$Device = (Get-AwtrixGlobal -Devices),                                           

        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Path,

        [Parameter(ValueFromPipelineByPropertyName)]                  [object  ]$FromFile,
        [Parameter(ValueFromPipelineByPropertyName)]                  [string  ]$Text
    )

    Begin {
    }

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            [PSCustomObject]@{

                Device = $d  
                Path   = $Path.Replace('\', '/')
                Text   = $Text    
            }
        }
    }

    End {
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Debug\Debug-AwtrixParameter.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Debug\Debug-AwtrixSettingsApi.ps1

function Debug-AwtrixSettingsApi([switch]$Raw2PS)
{
    @(
        $Script:AwtrixSettingsApi 
        $Script:AwtrixSettingsApiRaw2PS

    )[$Raw2PS.IsPresent]
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Debug\Debug-AwtrixSettingsApi.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Disable-Awtrix.ps1

function Disable-Awtrix
{
    [CmdletBinding(DefaultParameterSetName='Display')]
    param(
        [Parameter(ParameterSetName='Display'  )]
        [Parameter(ParameterSetName='App'      )]
        [Parameter(ParameterSetName='Indicator')]
                                                 [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                                   [string[]]$Device = (Get-AwtrixGlobal -Devices),                                           

        [Parameter(ParameterSetName='Display'  )][Parameter(ValueFromPipelineByPropertyName)]                                                     [switch  ]$Display,
                                          
        [Parameter(ParameterSetName='App'      )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -App       @args})][string[]]$App,
        [Parameter(ParameterSetName='App'      )][Parameter(ValueFromPipelineByPropertyName)]                                                     [switch  ]$Restart,
                                                                                                                                                       
        [Parameter(ParameterSetName='Indicator')][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Indicator @args})][string[]]$Indicator
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $body = @{}

            switch($PSCmdlet.ParameterSetName)
            {
                'Display' {
                
                    $apiPath = @(,"settings")

                    $body['MATP'] = $false
                }

                'Indicator' {

                    if('*' -in $Indicator)
                    {
                        $Indicator = Get-AwtrixArg -Indicator
                    }

                    $apiPath = @() + (ConvertTo-Awtrix -Indicator $Indicator).ForEach({"indicator$_"})
                }

                'App' {
                
                    $apiPath = @(,"settings")
                    
                    foreach($a in (ConvertTo-Awtrix -App $App))
                    {
                        $body[$a] = $false
                    } 
                }
            }

            Write-Verbose ($Body | ConvertTo-Json)

            $apiPath | ForEach-Object {

                $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/$($_)" -Body ($Body | ConvertTo-Json -Compress) -ContentType "application/json" -Verbose:$false

                if('OK' -ne $result) { $result }
            }

            if($Restart.IsPresent)
            {
                Restart-Awtrix -Device $d
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Disable-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Enable-Awtrix.ps1

function Enable-Awtrix
{
    [CmdletBinding(DefaultParameterSetName='Display')]
    param(
        [Parameter(ParameterSetName='Display'  )]
        [Parameter(ParameterSetName='App'      )]
        [Parameter(ParameterSetName='Indicator')]
                                                 [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                                   [string[]]$Device = (Get-AwtrixGlobal -Devices),                                           

        [Parameter(ParameterSetName='Display'  )][Parameter(ValueFromPipelineByPropertyName)]                                                     [switch  ]$Display,
                                          
        [Parameter(ParameterSetName='App'      )][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -App       @args})][string[]]$App,
        [Parameter(ParameterSetName='App'      )][Parameter(ValueFromPipelineByPropertyName)]                                                     [switch  ]$Restart,
                                                                                                                                                       
        [Parameter(ParameterSetName='Indicator')][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Indicator @args})][string[]]$Indicator,
        [Parameter(ParameterSetName='Indicator')][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -Color     @args})][object[]]$Color = "Green",
        [Parameter(ParameterSetName='Indicator')][Parameter(ValueFromPipelineByPropertyName)]                                                     [uint32  ]$Blink,
        [Parameter(ParameterSetName='Indicator')][Parameter(ValueFromPipelineByPropertyName)]                                                     [uint32  ]$Fade
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))
        {
            $body = @{}

            switch($PSCmdlet.ParameterSetName)
            {
                'Display' {
                
                    $apiPath = @(,"settings")

                    $body['MATP'] = $true
                }

                'Indicator' {

                    if('*' -in $Indicator)
                    {
                        $Indicator = Get-AwtrixArg -Indicator
                    }

                    $apiPath = @() + (ConvertTo-Awtrix -Indicator $Indicator).ForEach({"indicator$_"})

                    if($Color) { $body["color"] = ConvertTo-Awtrix -Color $Color }

                    if($Blink) { $body["blink"] = $Blink }
                    if($Fade ) { $body["fade" ] = $Fade  }
                }

                'App' {
                
                    $apiPath = @(,"settings")
                    
                    foreach($a in (ConvertTo-Awtrix -App $App))
                    {
                        $body[$a] = $true
                    } 
                }
            }

            Write-Verbose ($Body | ConvertTo-Json)

            $apiPath | ForEach-Object {

                $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/$($_)" -Body ($Body | ConvertTo-Json -Compress) -ContentType "application/json" -Verbose:$false

                if('OK' -ne $result) { $result }
            }

            if($Restart.IsPresent)
            {
                Restart-Awtrix -Device $d
            }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Enable-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Find-Awtrix.ps1

function Find-Awtrix
{
    [CmdletBinding()]
    param(
        [Parameter()][uint32]$Count         = 1,
        [Parameter()][uint32]$PollIntervall = 500,
        [Parameter()][uint32]$Timeout       = 5,

        [Parameter(ValueFromPipelineByPropertyName)][string]$Network
    )

    $DiscoverMessage = "FIND_AWTRIX"

    $ReceivePort   = 4211
    $BroadcastPort = 4210

    if($Network)
    {
        $IPAddress, $PrefixLength, $Rest = "$($Network)/24".Split("/")
    }
    else
    {
        $Network = Get-NetIPAddress -AddressFamily IPv4 | Select-Object -First 1

        $IPAddress    = $Network.IPAddress
        $PrefixLength = $Network.PrefixLength
    }

    if($IPAddress)
    {
        $Broadcast = @(@($IPAddress.Split('.')[0..(($PrefixLength/8)-1)]) + @("255", "255", "255", "255"))[0..3] -join '.'

        $socket = [System.Net.Sockets.Socket]::new([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Dgram, [System.Net.Sockets.ProtocolType]::Udp)

        $socket.EnableBroadcast = $true # $socket.SetSocketOption([System.Net.Sockets.SocketOptionLevel]::Socket,[System.Net.Sockets.SocketOptionName]::Broadcast, 1)

        $socket.ReceiveTimeout = 1000

        $socket.Bind([System.Net.IPEndPoint]::new([System.Net.IPAddress]::Parse($IPAddress), $ReceivePort))

        $result = [ordered]@{}

        $PollTime = 0

        $Timeout *= 1000

        do
        {
            [void]($socket.SendTo([System.Text.Encoding]::ASCII.GetBytes($DiscoverMessage), [System.Net.IPEndPoint]::new([System.Net.IPAddress]::Parse($Broadcast), $BroadcastPort)))

            Start-Sleep -Milliseconds $PollIntervall

            $PollTime += $PollIntervall

            while($socket.Available)
            {
                $receiveBuffer = [byte[]]::new(4096)

                $fromEndpoint  = [System.Net.IPEndPoint]::new([System.Net.IPAddress]::Any,0)

                $received = $socket.ReceiveFrom($receiveBuffer, [ref]$fromEndpoint);

                $Name = [System.Text.Encoding]::ASCII.GetString($receiveBuffer[0..$received])

                $result[$Name] = "$($fromEndpoint.Address)"
            }
        }
        until(($result.Count -eq $Count) -or ($PollTime -ge $Timeout))

        $socket.Close()

        $result
    }
}

# discover Awtrix via arp

[void]{

    Get-NetNeighbor -LinkLayerAddress      48-e7-29-*
            
    netsh int ipv4 show neighbor | findstr 48-e7-29

    arp -a                       | findstr 48-e7-29 
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Find-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Get-AwtrixNetwork.ps1

function Get-AwtrixNetwork
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)][string]$Name
    )

    $Property1 = @(

        @{ Name = "Medium"      ; Expression = { switch($_.NetAdapter.NdisPhysicalMedium) { 9 { 'Wifi' } 14 { 'Ethernet' } } } }
        @{ Name = "Interface"   ; Expression = {  $_.InterfaceAlias  } }
        @{ Name = "SSID"        ; Expression = {  $_.NetProfile.Name } }
        @{ Name = "IPAddress"   ; Expression = { ($_.IPv4Address | Select-Object -First 1).IPAddress    } }
        @{ Name = "PrefixLength"; Expression = { ($_.IPv4Address | Select-Object -First 1).PrefixLength } }
        @{ Name = "Device"      ; Expression = {  $_.InterfaceDescription } }
    )

    $Property2 = @(

        "Medium"
        "Interface"    
        "SSID"      
        "IPAddress"    
        "PrefixLength" 
        "Device"       

        @{ Name = "Name"   ; Expression = { "$($_.Medium)\$($_.Interface)\$($_.SSID)" } }
        @{ Name = "Network"; Expression = { "$($_.IPAddress)/$($_.PrefixLength)"      } }
    )

    $Filter = (@($Name, ".*") -ne $null) | Select-Object -First 1

    Get-NetIPConfiguration -Detailed | Where-Object { ($_.NetAdapter.Status -eq 'Up') -and ($_.NetAdapter.NdisPhysicalMedium -in (9,14)) } | Select-Object -Property $Property1 | Select-Object -Property $Property2 | Where-Object -Property Name -Match -Value $Filter
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Get-AwtrixNetwork.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Restart-Awtrix.ps1

function Restart-Awtrix
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][string[]]$Device = (Get-AwtrixGlobal -Devices)
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/reboot" -Body $null -Verbose:$false

            if('OK' -ne $result) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Restart-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixDashboard.ps1

function Show-AwtrixDashboard
{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][string[]]$Device  = (Get-AwtrixGlobal -Devices),
        [Parameter()]                                                 [switch  ]$Logo    = $true,
        [Parameter()][ValidateRange(1,2)]                             [uint32  ]$Columns = 2
    )

    Begin {

        $htmlFile = "$($env:TEMP)\$($Script:ModuleItem.BaseName).DashBoard.html"

        $list = [System.Collections.Generic.List[PSCustomObject]]::new()
    }

    Process {

        foreach($o in (Resolve-AwtrixAlias $Device -AsObject))
        {
            $list.Add($o)
        }
    }

    End {

        if(($Columns -eq 2) -and ($list.Count % 2)) { $list.Add($null) }
@"
        <!DOCTYPE html>
        <html>
            <head>
                <style>

                    .header {

                        font-family: Arial, Helvetica, sans-serif;
                        font-weight: bold;
                        font-size:   150%;
                
                    }

                    .screen {

                        background: #000000;
                        border:     none;
                    }

                    .liveview {

                        scale:       90%;
                        width:      800px;
                        height:     200px; 
                        background: #000000;
                        border:     none;
                    }
                </style>
            </head>

            <body>
$(
        if($Logo)
        {
@"
                <p>
                    <img src="$(Get-ChildItem -Path "$(Get-AwtrixModulePath -Images)\*.Logo.png" | Sort-Object BaseName | Select-Object -First 1)" width="10%" height="10%"/>
                </p>
"@
        }
)

                <table class="table">
$(
        if($Columns -eq 1)
        {
            for($zz = 0; $zz -lt $list.Count; $zz++)
            {
@"
                    <tr>
                        <td class="header"><div>$($list[$zz+0].Alias)</div></td>
                    </tr>
                    <tr>
                        <td class="screen"><iframe class="liveview" src="http://$($list[$zz+0].Device)/fullscreen"></iframe></td>
                    </tr>
"@
            }
        }
        else
        {
            for($zz = 0; $zz -lt $list.Count; $zz += 2)
            {
@"
                    <tr>
                        <td class="header"><div>$($list[$zz+0].Alias)</div></td>
                        <td class="header"><div>$($list[$zz+1].Alias)</div></td>
                    </tr>
                    <tr>
                        <td class="screen"><iframe class="liveview" src="http://$($list[$zz+0].Device)/fullscreen"></iframe></td>
"@
                if($list[$zz+1])
                {
@"
                        <td class="screen"><iframe class="liveview" src="http://$($list[$zz+1].Device)/fullscreen"></iframe></td>
"@
                }
@"
                    </tr>
"@
            }
        }
)
                </table>
            </body>
        </html>

"@ | Out-File -FilePath $htmlFile

        # start microsoft-edge:https://url.de

        explorer $htmlFile
    }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixDashboard.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixDocs.ps1

function Show-AwtrixDocs
{
    [CmdletBinding(DefaultParameterSetName='Default')]

    param(
        [Parameter(ParameterSetName='GitHub' )][switch]$GitHub,
        [Parameter(ParameterSetName='Flasher')][switch]$Flasher,
        [Parameter(ParameterSetName='ReadMe' )][switch]$ReadMe, 
        [Parameter(ParameterSetName='Effects')][switch]$Effects,
        [Parameter(ParameterSetName='DevJson')][switch]$DevJson,
        [Parameter(ParameterSetName='Module' )][switch]$Module 
    )

    Begin {

        $url = @{

            Default = "https://blueforcer.github.io/awtrix3/#/"

            GitHub  = 'https://github.com/Blueforcer/awtrix3'
            Flasher = 'https://blueforcer.github.io/awtrix3/#/flasher'
            ReadMe  = 'https://blueforcer.github.io/awtrix3/#/README'
            Effects = 'https://blueforcer.github.io/awtrix3/#/effects'
            DevJson = 'https://blueforcer.github.io/awtrix3/#/dev'

            Module  = "https://github.com/Flittermelint/PSAwtrix3"

        }[$PSCmdlet.ParameterSetName]
    }

    Process {

        Start-Process "microsoft-edge:$url"
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixDocs.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixLinkList.ps1

function Show-AwtrixLinkList
{
    Begin {

        $htmlFile = "$($env:TEMP)\$($Script:ModuleItem.BaseName).LinkList.html"

        $list = @(

            [PSCustomObject]@{ Title = "Smart Home Junkie: BEST MATRIX DISPLAY CLOCK for Home Assistant!"; Url = "https://www.smarthomejunkie.net/this-is-the-best-matrix-display-clock-for-home-assistant/" }
            [PSCustomObject]@{ Title = "JBetzen Blog: Ulanzi Smart Pixel Clock TC001"                    ; Url = "https://jbetzen.net/posts/pixelclock/"                                                     }

            # https://www.piskelapp.com/
            # https://onlinegiftools.com/add-gif-background
            # https://developer.lametric.com/icons
            # https://developer.lametric.com/content/apps/icon_thumbs/87_icon_thumb.gif
        )
    }

    Process {

@"
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                </style>
            </head>

            <body>
                <p>
                    <img src="$(Get-ChildItem -Path "$(Get-AwtrixModulePath -Images)\*.Logo.png" | Sort-Object BaseName | Select-Object -First 1)" width="50%" height="50%"/>
                </p>
$(
        foreach($item in $list)
        {
@"
                <p><a href="$($item.Url)">$($item.Title)</a></p>
"@
        }
)
            </body>
        </html>

"@ | Out-File -FilePath $htmlFile

        # start microsoft-edge:https://url.de

        explorer $htmlFile
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixLinkList.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixWebPage.ps1

[void]{

    Start-Process "microsoft-edge:https://devdojo.com/hcritter/powershell-technique-smart-aliases"
}

function Show-AwtrixWebPage
{
    [CmdletBinding()]

    [Alias("Show-AwtrixFiles"
          ,"Show-AwtrixUpdate"
          ,"Show-AwtrixLiveView"
          ,"Show-AwtrixFullscreen"
          ,"Show-AwtrixBackup"
          )]

    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][string[]]$Device = (Get-AwtrixGlobal -Devices)
    )

    Begin { }

    Process {

        $Splat = @{

            "$($PSCmdlet.MyInvocation.InvocationName.Substring(11))" = $true
        }

        Show-Awtrix -Device $Device @Splat
    }

    End { }
}

function Show-Awtrix
{
    [CmdletBinding(DefaultParameterSetName='WebPage')]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][string[]]$Device = (Get-AwtrixGlobal -Devices),

        [Parameter(ParameterSetName='WebPage'   )][switch]$WebPage,

        [Parameter(ParameterSetName='Files'     )][switch]$Files,
        [Parameter(ParameterSetName='Update'    )][switch]$Update,
        [Parameter(ParameterSetName='LiveView'  )][switch]$LiveView,
        [Parameter(ParameterSetName='Fullscreen')][switch]$Fullscreen,
        [Parameter(ParameterSetName='Backup'    )][switch]$Backup
    )

    Begin {

        $apiPath = @{

            WebPage    = ''

            Files      = 'edit'
            Update     = 'update'
            LiveView   = 'screen'
            FullScreen = 'fullscreen'
            Backup     = 'backup'

        }[$PSCmdlet.ParameterSetName]
    }

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            Start-Process "microsoft-edge:http://$($d)/$($apiPath)"
        }
    }

    End { }
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-AwtrixWebPage.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-RTTTLPlayer.ps1

function Show-RTTTLPlayer
{
    Start-Process microsoft-edge:https://adamonsoon.github.io/rtttl-play/
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Show\Show-RTTTLPlayer.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Switch-Awtrix.ps1

$Script:AwtrixSwitchApi = [ordered]@{

    App = @("name", { $args })
}

function Switch-Awtrix
{
    [CmdletBinding()]
    param(
                                              [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                             [string[]]$Device = (Get-AwtrixGlobal -Devices),                                           
                                                                                                                                                       
        [Parameter(ParameterSetName='Next'  )][Parameter(ValueFromPipelineByPropertyName)]                                               [switch  ]$Next,
        [Parameter(ParameterSetName='Prev'  )][Parameter(ValueFromPipelineByPropertyName)][Alias("Prev")]                                [switch  ]$Previous,
                                          
        [Parameter(ParameterSetName='Switch')][Parameter(ValueFromPipelineByPropertyName)][ArgumentCompleter({Get-AwtrixArg -App @args})][string  ]$App
    )

    Begin {

        $api = @{

            Next   = 'nextapp'
            Prev   = 'previousapp'
            Switch = 'switch'
        }
    }

    Process {
    
        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $Body = New-AwtrixApiBody -Api $Script:AwtrixSwitchApi -BoundParameters $PSBoundParameters

            Write-Verbose ($Body | ConvertTo-Json)

            $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/$($api[$PSCmdlet.ParameterSetName])" -Body ($Body | ConvertTo-Json -Compress) -ContentType "application/json" -Verbose:$false

            if('OK' -ne $result) { $result }
        }
    }

    End {}
}

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Switch-Awtrix.ps1

#region Origin:\\PSAwtrix3\0.0.0\ps1\Write-Awtrix.ps1

[void]{

    Start-Process "microsoft-edge:https://www.compart.com/de/unicode"
}

$AwtrixNotifyApi = [ordered]@{
    #                                                                                                    # ? tested ok 
    #                                                                                                    # ? tested doesn't work
    #                                                                                                    # ? not tested or unknown how this should work

    #                                                                                                    #    ParameterName         # Key            Type                        Description                                                                                                                                                                  Default CustomApp Notification
    #                                                                                                    #    --------------------- # ---            ----                        -----------                                                                                                                                                                  ------- --------- ------------
    Text                  = @("text          ", {                                               $args }) # ? Text                  # text           string                      The text to display. Keep in mind the font does not have a fixed size and I uses less space than W. This facts affects when text will start scrolling                        N/A     X         X
    TextCase              = @("textCase      ", {                    ConvertTo-Awtrix -TextCase $args }) # ? TextCase              # textCase       integer                     Changes the Uppercase setting. 0=global setting, 1=forces uppercase; 2=shows as it sent.                                                                                     0       X         X
    TopText               = @("topText       ", {                    ConvertTo-Awtrix -Bool     $args }) # ? TopText               # topText        boolean                     Draw the text on top.                                                                                                                                                        false   X         X
    TextOffset            = @("textOffset    ", {                                               $args }) # ? TextOffset            # textOffset     integer                     Sets an offset for the x position of a starting text.                                                                                                                        0       X         X
    Center                = @("center        ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Center                # center         boolean                     Centers a short, non-scrollable text.                                                                                                                                        true    X         X

    Color                 = @("color         ", {                    ConvertTo-Awtrix -Color    $args }) # ? Color                 # color          string or array of integers The text, bar or line color.                                                                                                                                                 N/A     X         X
    Background            = @("background    ", {                    ConvertTo-Awtrix -Color    $args }) # ? Background            # background     string or array of integers Sets a background color.                                                                                                                                                     N/A     X         X

    Gradient              = @("gradient      ", { $args | For-Each { ConvertTo-Awtrix -Color    $_  } }) # ? Gradient              # gradient       Array of string or integers Colorizes the text in a gradient of two given colors                                                                                                                         N/A     X         X

    BlinkText             = @("blinkText     ", {                                               $args }) # ? BlinkText             # blinkText      Integer                     Blinks the text            in an given interval (millisecconds), not compatible with gradient or rainbow                                                                                                N/A     X         X
    FadeText              = @("fadeText      ", {                                               $args }) # ? FadeText              # fadeText       Integer                     Fades  the text on and off in an given interval (millisecconds), not compatible with gradient or rainbow                                                                                      N/A     X         X

    Rainbow               = @("rainbow       ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Rainbow               # rainbow        boolean                     Fades each letter in the text differently through the entire RGB spectrum.                                                                                                   false   X         X

    Icon                  = @("icon          ", {                                               $args }) # ? Icon                  # icon           string                      The icon ID or filename (without extension) to display on the app.                                                                                                           N/A     X         X
    MoveIcon              = @("pushIcon      ", {                    ConvertTo-Awtrix -MoveIcon $args }) # ? MoveIcon              # pushIcon       integer                     0 = Icon doesn't move. 1 = Icon moves with text and will not appear again. 2 = Icon moves with text but appears again when the text starts to scroll again.                  0       X         X

    Repeat                = @("repeat        ", {                                               $args }) # ? Repeat                # repeat         integer                     Sets how many times the text should be scrolled through the matrix before the app ends.                                                                                      -1      X         X
    Duration              = @("duration      ", {                                               $args }) # ? Duration              # duration       integer                     Sets how long the app or notification should be displayed.                                                                                                                   5       X         X
    Hold                  = @("hold          ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Hold                  # hold           boolean                     Set it to true, to hold your notification on top until you press the middle button or dismiss it via HomeAssistant. This key only belongs to notification.                   false             X

    Sound                 = @("sound         ", {                                               $args }) # ? Sound                 # sound          string                      The filename of your RTTTL ringtone file placed in the MELODIES folder (without extension).                                                                                  N/A               X
    RTTTL                 = @("rtttl         ", {                                               $args }) # ? RTTTL                 # rtttl          string                      Allows to send the RTTTL sound string with the json.                                                                                                                         N/A               X
    LoopSound             = @("loopSound     ", {                    ConvertTo-Awtrix -Bool     $args }) # ? LoopSound             # loopSound      boolean                     Loops the sound or rtttl as long as the notification is running.                                                                                                             false             X

    Bar                   = @("bar           ", {                                               $args }) # ? Bar                   # bar            array of integers           Draws a bargraph. Without icon maximum 16 values, with icon 11 values.                                                                                                       N/A     X         X
    Line                  = @("line          ", {                                               $args }) # ? Line                  # line           array of integers           Draws a linechart. Without icon maximum 16 values, with icon 11 values.                                                                                                      N/A     X         X
    Autoscale             = @("autoscale     ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Autoscale             # autoscale      boolean                     Enables or disables autoscaling for bar and linechart.                                                                                                                       true    X         X

    ProgressBar           = @("progress      ", {                                               $args }) # ? ProgressBar           # progress       integer                     Shows a progress bar. Value can be 0-100.                                                                                                                                    -1      X         X
    ProgressBarColor      = @("progressC     ", {                    ConvertTo-Awtrix -Color    $args }) # ? ProgressBarColor      # progressC      string or array of integers The color of the progress bar.                                                                                                                                               -1      X         X
    ProgressBarBackground = @("progressBC    ", {                    ConvertTo-Awtrix -Color    $args }) # ? ProgressBarBackground # progressBC     string or array of integers The color of the progress bar background.                                                                                                                                    -1      X         X

    Draw                  = @("draw          ", {                    ConvertTo-Awtrix -Json     $args }) # ? Draw                  # draw           array of objects            Array of drawing instructions. Each object represents a drawing command. See the drawing instructions below.                                                                         X         X
    Stack                 = @("stack         ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Stack                 # stack          boolean                     Defines if the notification will be stacked. false will immediately replace the current notification.                                                                        true              X
    Wakeup                = @("wakeup        ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Wakeup                # wakeup         boolean                     If the Matrix is off, the notification will wake it up for the time of the notification.                                                                                     false             X

    Scroll                = @("noScroll      ", {                    ConvertTo-Awtrix -BoolNot  $args }) # ? Scroll                # noScroll       boolean                     Disables the text scrolling.                                                                                                                                                 false   X         X
    ScrollSpeedPercent    = @("scrollSpeed   ", {                                               $args }) # ? ScrollSpeed           # scrollSpeed    integer                     Modifies the scroll speed. Enter a percentage value of the original scroll speed.                                                                                            100     X         X

    Clients               = @("clients       ", {                    ConvertTo-Awtrix -Clients  $args }) # ? Clients               # clients        array of strings            Allows forwarding a notification to other awtrix devices. Use the MQTT prefix for MQTT and IP addresses for HTTP.                                                                              X

    Effect                = @("effect        ", {                                               $args }) # ? Effect                # effect         string                      Shows an effect as background.The effect can be removed by sending an empty string for effect                                                                                        X         X
    EffectSettings        = @("effectSettings", {                                               $args }) # ? EffectSettings        # effectSettings json map                    Changes color and speed of the effect.                                                                                                                                               X         X

    Pos                   = @("pos           ", {                                               $args }) # ? Pos                   # pos            integer                     Defines the position of your custom page in the loop, starting at 0 for the first position. This will only apply with your first push. This function is experimental.        N/A     X          
    Lifetime              = @("lifetime      ", {                                               $args }) # ? Lifetime              # lifetime       integer                     Removes the custom app when there is no update after the given time in seconds.                                                                                              0       X          
    LifetimeMode          = @("lifetimeMode  ", {                    ConvertTo-Awtrix -LifeMode $args }) # ? LifetimeMode          # lifetimeMode   integer                     0 = deletes the app, 1 = marks it as staled with a red rectangle around the app                                                                                              0       X          
    Save                  = @("save          ", {                    ConvertTo-Awtrix -Bool     $args }) # ? Save                  # save           boolean                     Saves your custom app into flash and reloads it after boot. Avoid this for custom apps with high update frequencies because the ESP's flash memory has limited write cycles.         X          
}

$AwtrixNotifyApiRaw2PS = [ordered]@{}

foreach($kv in $AwtrixNotifyApi.GetEnumerator())
{
    $AwtrixNotifyApiRaw2PS[$kv.Value[0].Trim()] = $kv.Key
}

function Write-Awtrix
{
    [CmdletBinding(DefaultParameterSetName='Notify')]
    [Alias("Out-Awtrix")]
    param(
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]                                                      [string[]]$Device = (Get-AwtrixGlobal -Devices),                                           

                                              [Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [string  ]$CustomApp            , # string                      The text to display. Keep in mind the font does not have a fixed size and I uses less space than W. This facts affects when text will start scrolling                        N/A     X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [string  ]$Text                 , # string                      The text to display. Keep in mind the font does not have a fixed size and I uses less space than W. This facts affects when text will start scrolling                        N/A     X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -TextCase @args})][string  ]$TextCase             , # integer                     Changes the Uppercase setting. 0=global setting, 1=forces uppercase; 2=shows as it sent.                                                                                     0       X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$TopText              , # boolean                     Draw the text on top.                                                                                                                                                        false   X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$TextOffset           , # integer                     Sets an offset for the x position of a starting text.                                                                                                                        0       X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Center               , # boolean                     Centers a short, non-scrollable text.                                                                                                                                        true    X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -Color    @args})][object[]]$Color                , # string or array of integers The text, bar or line color.                                                                                                                                                 N/A     X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -Color    @args})][object[]]$Background           , # string or array of integers Sets a background color.                                                                                                                                                     N/A     X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)][ValidateCount(2,2)][ArgumentCompleter({Get-AwtrixArg -Color    @args})][string[]]$Gradient             , # Array of string or integers Colorizes the text in a gradient of two given colors                                                                                                                         N/A     X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$BlinkText            , # Integer                     Blinks the text in an given interval, not compatible with gradient or rainbow                                                                                                N/A     X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$FadeText             , # Integer                     Fades the text on and off in an given interval, not compatible with gradient or rainbow                                                                                      N/A     X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Rainbow              , # boolean                     Fades each letter in the text differently through the entire RGB spectrum.                                                                                                   false   X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [string  ]$Icon                 , # string                      The icon ID or filename (without extension) to display on the app.                                                                                                           N/A     X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -MoveIcon @args})][uint32  ]$MoveIcon             , # integer                     0 = Icon doesn't move. 1 = Icon moves with text and will not appear again. 2 = Icon moves with text but appears again when the text starts to scroll again.                  0       X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$Repeat               , # integer                     Sets how many times the text should be scrolled through the matrix before the app ends.                                                                                      -1      X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$Duration             , # integer                     Sets how long the app or notification should be displayed.                                                                                                                   5       X         X
        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Hold                 , # boolean                     Set it to true, to hold your notification on top until you press the middle button or dismiss it via HomeAssistant. This key only belongs to notification.                   false             X

        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)][Alias('Melody')]                                                       [string  ]$Sound                , # string                      The filename of your RTTTL ringtone file placed in the MELODIES folder (without extension).                                                                                  N/A               X
        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [string  ]$RTTTL                , # string                      Allows to send the RTTTL sound string with the json.                                                                                                                         N/A               X
        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$LoopSound            , # boolean                     Loops the sound or rtttl as long as the notification is running.                                                                                                             false             X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32[]]$Bar                  , # array of integers           Draws a bargraph. Without icon maximum 16 values, with icon 11 values.                                                                                                       N/A     X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32[]]$Line                 , # array of integers           Draws a linechart. Without icon maximum 16 values, with icon 11 values.                                                                                                      N/A     X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Autoscale            , # boolean                     Enables or disables autoscaling for bar and linechart.                                                                                                                       true    X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)][ValidateRange(0,100)]                                                  [uint32  ]$ProgressBar          , # integer                     Shows a progress bar. Value can be 0-100.                                                                                                                                    -1      X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -Color    @args})][object[]]$ProgressBarColor     , # string or array of integers The color of the progress bar.                                                                                                                                               -1      X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -Color    @args})][object[]]$ProgressBarBackground, # string or array of integers The color of the progress bar background.                                                                                                                                    -1      X         X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [object[]]$Draw                 , # array of objects            Array of drawing instructions. Each object represents a drawing command. See the drawing instructions below.                                                                         X         X
        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Stack                , # boolean                     Defines if the notification will be stacked. false will immediately replace the current notification.                                                                        true              X
        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Wakeup               , # boolean                     If the Matrix is off, the notification will wake it up for the time of the notification.                                                                                     false             X

        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Scroll               , # boolean                     Disables the text scrolling.                                                                                                                                                 false   X         X
        [Parameter(ParameterSetName='Notify')][Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$ScrollSpeed          , # integer                     Modifies the scroll speed. Enter a percentage value of the original scroll speed.                                                                                            100     X         X

        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [string[]]$Clients              , # array of strings            Allows forwarding a notification to other awtrix devices. Use the MQTT prefix for MQTT and IP addresses for HTTP.                                                                              X

        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -Effect   @args})][string  ]$Effect               , # string                      Shows an effect as background.The effect can be removed by sending an empty string for effect                                                                                        X         X
        [Parameter(ParameterSetName='Notify')]                                      [Parameter(ValueFromPipelineByPropertyName)]                                                                        [object  ]$EffectSettings       , # json map                    Changes color and speed of the effect.                                                                                                                                               X         X
                                                                                                            
                                              [Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$Pos                  , # integer                     Defines the position of your custom page in the loop, starting at 0 for the first position. This will only apply with your first push. This function is experimental.        N/A     X          
                                              [Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [uint32  ]$Lifetime             , # integer                     Removes the custom app when there is no update after the given time in seconds.                                                                                              0       X          
                                              [Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                    [ArgumentCompleter({Get-AwtrixArg -LifeMode @args})][string  ]$LifetimeMode         , # integer                     0 = deletes the app, 1 = marks it as staled with a red rectangle around the app                                                                                              0       X          
                                              [Parameter(ParameterSetName='Custom')][Parameter(ValueFromPipelineByPropertyName)]                                                                        [switch  ]$Save                   # boolean                     Saves your custom app into flash and reloads it after boot. Avoid this for custom apps with high update frequencies because the ESP's flash memory has limited write cycles.         X          
    )

    Begin {}

    Process {

        foreach($d in (Resolve-AwtrixAlias $Device))  
        {
            $Body = New-AwtrixApiBody -Api $AwtrixNotifyApi -BoundParameters $PSBoundParameters

            Write-Verbose ($Body | ConvertTo-Json)

            $apiPath = switch($PSCmdlet.ParameterSetName)
            {
                Notify { "notify" }
                Custom { "custom?name=$($CustomApp)"}
            }

            $result = Invoke-RestMethod -Method Post -Uri "http://$($d)/api/$($apiPath)" -Body ($Body | ConvertTo-Json -Compress) -ContentType "application/json" -Verbose:$false

            if('OK' -ne $result) { $result }
        }
    }

    End {}
}

<#
{
  "text": [
    {
      "t": "Hello, ",
      "c": "FF0000"
    },
    {
      "t": "world!",
      "c": "00FF00"
    }
  ],
  "repeat": 2
}
#>

#endregion Origin:\\PSAwtrix3\0.0.0\ps1\Write-Awtrix.ps1


$Export = @{

    Function = @"
    
            Get-AwtrixModulePath

            Get-AwtrixNetwork

           Find-Awtrix

       Register-AwtrixAlias
            Get-AwtrixAlias
        Resolve-AwtrixAlias

            Set-AwtrixGlobal
            Get-AwtrixGlobal

           Show-Awtrix
           Show-AwtrixWebPage
           Show-AwtrixDocs
           Show-AwtrixDashBoard
           Show-AwtrixLinkList

         Switch-Awtrix
         
         Enable-Awtrix
         Enable-AwtrixDisplay
         Enable-AwtrixApp
         Enable-AwtrixIndicator

        Disable-Awtrix
        Disable-AwtrixDisplay
        Disable-AwtrixApp
        Disable-AwtrixIndicator

          Write-Awtrix
          Clear-Awtrix

            New-AwtrixDrawing
            New-AwtrixPixel    
            New-AwtrixLine     
            New-AwtrixRectangle
            New-AwtrixCircle   
            New-AwtrixText     
            New-AwtrixBitmap   
            
            Get-AwtrixEffectSettings

        Restart-Awtrix

            Get-Awtrix
            Set-Awtrix

            Get-AwtrixChildItem

            Get-AwtrixItemContent
            Set-AwtrixItemContent

            Set-AwtrixIcon
            Set-AwtrixMelody
            Set-AwtrixPalette

            New-AwtrixDirectory

         Remove-AwtrixItem
         Rename-AwtrixItem

           Show-RTTTLPlayer

            Get-AwtrixIconFromModule
            Get-AwtrixMelodyFromModule
            Get-AwtrixPaletteFromModule

            Get-AwtrixDevJson
            Set-AwtrixDevJson
         Remove-AwtrixDevJson

            Set-AwtrixDevJsonProperty
         Remove-AwtrixDevJsonProperty

            Get-AwtrixArg

$(if('-Debug' -in $args)
{
@"
            New-AwtrixApiBody

    ConvertFrom-Awtrix

      ConvertTo-Awtrix
      ConvertTo-AwtrixColor

        Convert-AwtrixValue

            New-AwtrixValueConverter

          Debug-AwtrixSettingsApi
          Debug-AwtrixNotifyApi
"@
})
"@

    Alias    = @"

           Show-AwtrixFiles
           Show-AwtrixUpdate
           Show-AwtrixLiveView
           Show-AwtrixFullscreen
           Show-AwtrixBackup

            Out-Awtrix

            New-AwtrixItem
            New-AwtrixIcon
            New-AwtrixMelody
            New-AwtrixPalette

            Get-AwtrixIcons
            Get-AwtrixCustomApps
            Get-AwtrixMelodies
            Get-AwtrixPalettes

           Move-AwtrixItem

           Drawing
           Draw
           Pixel    
           Line     
           Rectangle
           Rect
           Circle   
           Text     
           Bitmap   
"@
}

$Keys = @($Export.Keys); foreach($Key in $Keys) { $Export[$Key] = $Export[$Key].Split([char[]]@(0x0a, 0x0d), [System.StringSplitOptions]::RemoveEmptyEntries).ForEach({$_.Trim()}) } 

Export-ModuleMember @Export
