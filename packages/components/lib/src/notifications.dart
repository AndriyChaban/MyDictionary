import 'package:flutter/material.dart';

abstract class DrawerNotification extends Notification {}

class OpenDrawerNotification extends DrawerNotification {}

class CloseDrawerNotification extends DrawerNotification {}
