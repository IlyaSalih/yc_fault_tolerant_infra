resource "yandex_compute_snapshot_schedule" "daily" {
  name = "coursework-daily-snapshots"

  schedule_policy {
    expression = "0 3 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
    description = "Daily automated snapshot (coursework fault-tolerant infra)"
  }

  disk_ids = var.disk_ids
}