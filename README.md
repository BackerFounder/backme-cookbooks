Backme Cookbooks
===

## Requirements

* Ruby 2.6+
* Vagrant
* Chef Workstation (Chef DK)

## Usage

Use `kitchen test` to confirm the cookbooks works correctly.

```
kitchen test

# ...
```

To customize `attributes` or other kitchen configs, create `kitchen.local.yml` for testing.

```
cp kitchen.yml kitchen.local.yml
```

### Data Bag

In the AWS OpsWorks, the stack and app information will put into Data Bag in Chef 12, to access these data in the test we can put them into `test/data_bags` directory.

```
echo '{ "name": "rails" }' > test/data_bags/aws_opsworks_app/test.json
```

> Please note the `aws_opsworks_app` keyword is a directory that can put multiple files.

### Cookbook

1. To add a new `cookbook` use the `chef generate cookbook [name]` to add it.
2. Add `cookbook '[name]', path: './[name]'` to `Berksfile`
3. Run `berks install` to update cookbook references

### Package

Run `berks package` to generate offline cookbooks for AWS OpsWorks to run recipes.
