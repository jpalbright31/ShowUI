## Select-ChildControl (aka: Get-ChildControl) and Select-UIElement are deprecated because Export-NamedControls is a better way
function Select-UIElement
{
    <#
    .Synopsis
        Gets a Child UIElement anywhere in a visual tree
    .Description
        Gets a Child UIElement anywhere in a visual tree
    .Example
        $window | Select-ChildControl FooBar
    .Parameter name
        The name of the control to look for
    .Parameter Parent
        The root of the visual tree to look in    
    #>        
    param(
    [Parameter(Position=0)][string]$name = "*"
,   [Parameter(ValueFromPipeline=$true, Position=1)]$Parent = $ShowUI.ActiveWindow
    )
    process {
      Invoke-UIElement $Parent {
         Select-ChildControl $Name $Parent
      }
   }
}

filter Select-ChildControl {
param(
   [Parameter(Position=0)]
   [string]$Name
,
   [Parameter(ValueFromPipeline=$true, Position=1)]
   $Parent
)
   if(!$Parent) { return }
   Write-Verbose "This $($Parent.GetType().Name) is $($Parent)"
  
   $Parent | Where-Object { $_ -and $_.Name -like $name }
   @(@($Parent.Children) + @($Parent.Child) + @($Parent.Content) + 
     @($Parent.Items) + @($Parent.Inlines) + @($Parent.Blocks)    ) | Select-ChildControl $Name
}
