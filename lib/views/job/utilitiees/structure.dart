import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/firebase.dart';
import 'package:jeya_engineering/models/job.dart';
import 'package:jeya_engineering/views/job/job_list.dart';
import 'package:jeya_engineering/views/job/new_job_list.dart';
import 'package:jeya_engineering/widgets/utilities.dart';

class JobCell extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;

  const JobCell({
    Key? key,
    required this.job,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        job.number.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DesignStatus extends StatelessWidget {
  final Job job;
  final VoidCallback? Tap;

  const DesignStatus({Key? key, required this.job, this.Tap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: auth,
      builder: (_) {
        return auth.design
            ? Switch(
                value: job.design,
                onChanged: (val) {
                  job.design = val;
                  job.update(nameCheck: false);
                })
            : SizedBox(
                width: getWidth(context) * 0.02,
                child: getIcon(job.design),
              );
      },
    );
  }
}

class PurchaseStatus extends StatelessWidget {
  final Job job;
  final VoidCallback? Tap;

  const PurchaseStatus({Key? key, required this.job, this.Tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: auth,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: getWidth(context) * 0.02,
            child: getIcon(job.purchaseStatus == true),
          ),
        );
      },
    );
  }
}

class StoreStatus extends StatelessWidget {
  final Job job;
  final VoidCallback? Tap;

  const StoreStatus({Key? key, required this.job, this.Tap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: auth,
        builder: (_) {
          return SizedBox(
            width: getWidth(context) * 0.05,
            child: (auth.store)
                ? Switch(
                    value: job.storeStatus ?? false,
                    onChanged: (val) {
                      job.storeStatus = val;
                      job.update(nameCheck: false);
                    })
                : getIcon(job.storeStatus ?? false),
          );
        });
  }
}

class ProductionLathe extends StatelessWidget {
  final Job job;
  final VoidCallback? Tap;

  const ProductionLathe({Key? key, required this.job, this.Tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: auth,
        builder: (_) {
          return SizedBox(
            width: getWidth(context) * 0.05,
            child: (auth.productionLathe)
                ? Switch(
                    value: job.productionLathe ?? false,
                    onChanged: (val) {
                      job.productionLathe = val;
                      job.update(nameCheck: false);
                    })
                : getIcon(job.productionLathe ?? false),
          );
        });
  }
}

class ProductionFab extends StatelessWidget {
  final Job job;
  final VoidCallback? Tap;

  const ProductionFab({Key? key, required this.job, this.Tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: auth,
        builder: (_) {
          return SizedBox(
            width: getWidth(context) * 0.05,
            child: (auth.productionFab)
                ? Switch(
                    value: job.productionFabrication ?? false,
                    onChanged: (val) {
                      job.productionFabrication = val;
                      job.update(nameCheck: false);
                    })
                : getIcon(job.productionLathe ?? false),
          );
        });
  }
}

class ArchiveButton extends StatelessWidget {
  final Job job;
  final VoidCallback? Tap;
  final bool? isArchive;

  const ArchiveButton({Key? key, required this.job, this.Tap, this.isArchive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (auth.sales || auth.admin) == true
        ? ElevatedButton(
            onPressed: auth.sales && isArchive == false
                ? () {
                    archivedJobs
                        .add(job.toJson())
                        .then((value) => jobs.doc(job.docId).delete());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewJobList()));
                  }
                : () {
                    Job tempJob = job;

                    tempJob.add().then((value) {
                      archivedJobs.doc(job.docId).delete();
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewJobList()));
                  },
            child: Text((auth.admin ||
                        auth.ProductionAll ||
                        auth.sales ||
                        auth.design ||
                        auth.delivery ||
                        auth.productionFab ||
                        auth.productionFabassembly ||
                        auth.productionLathe ||
                        auth.finance ||
                        auth.purchase ||
                        auth.sales) &&
                    isArchive == false
                ? 'Move to Archive'
                : 'Move to jobs'),
          )
        : ElevatedButton(
            onPressed: null,
            child: Text((auth.admin ||
                        auth.ProductionAll ||
                        auth.sales ||
                        auth.design ||
                        auth.delivery ||
                        auth.productionFab ||
                        auth.productionFabassembly ||
                        auth.productionLathe ||
                        auth.finance ||
                        auth.purchase ||
                        auth.sales) &&
                    isArchive == false
                ? 'Move to Archive'
                : 'Move to jobs'),
          );
  }
}

Icon getIcon(bool val) =>
    Icon(Icons.flag, color: val ? Colors.green : Colors.red);
