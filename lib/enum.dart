import 'package:flutter/material.dart';

enum FormMode { add, edit }

enum Priority { low, medium, high }

enum Role { admin,design , sales,purchase,store,productionLathe,productionFab,productionFabassemmbly,productionAll,delivery,finance }

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 650;

bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 650;

bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;
