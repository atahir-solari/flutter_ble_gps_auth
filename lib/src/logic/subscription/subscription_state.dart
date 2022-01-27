class SubscriptionState {
  SubscriptionState({
    this.freeRam = '0',
    this.cpuTemperature = '0',
    this.systemTemperature = '0',
    this.cpuUsage = '0',
    this.sensorTemperature = '0',
    this.freeDisk = '0',
    this.isError = false,
  });

  final String freeRam;
  final String cpuTemperature;
  final String systemTemperature;
  final String cpuUsage;
  final String sensorTemperature;
  final String freeDisk;
  final bool isError;
}
