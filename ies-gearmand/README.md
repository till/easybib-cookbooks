# ies-gearmand-cookbook

A cookbook to install and configure gearmand from ondreij's PPA.

## Supported Platforms

 - Ubuntu 14.04 and 16.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ies-gearmand']['port']</tt></td>
    <td>Int</td>
    <td>The port to run gearman-job-server on</td>
    <td><tt>31337</tt></td>
  </tr>
  <tr>
    <td><tt>['ies-gearmand']['log']</tt></td>
    <td>String</td>
    <td>Log arguments</td>
    <td><tt>--syslog -l stderr</tt></td>
  </tr>
</table>

## Usage

### ies-gearmand::default

Include `ies-gearmand` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ies-gearmand::default]"
  ]
}
```

## License and Authors

Author:: Till Klampaeckel
