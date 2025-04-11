resource "apstra_configlet" "example" {
  name = var.name
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = <<-EOT
        ether-options {
          802.3ad {
            lacp {
              force-up;
            }
          }
        }
      EOT
    },
  ]
}
