class bamgrid::yaml_parser {

$resources = hiera_array("install", undef)

  if ($resources) {
    each($resources) |$resource| {
      if $resource['type'] {
        create_resources($resource['type'], $resource['values'])
      } elsif $resource['module'] {
        include $resource['module']
      } elsif $resource['class'] {
        create_resources("class", $resource['class'])
      } else {
        notify { "$resource":
          message => "$resource seems to be malformed data",
        } 
      }
    }
  }
  else {
    notify { 'Empty Install Phase':
      message => 'No resources found in the install phase',
    }
  }

}
