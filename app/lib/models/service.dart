class Service {
  final int id;
  final String title;
  final String? description;
  final int departmentId;
  final int duration; // in minutes
  final bool isActive;
  final int remainingAppointments;

  const Service({
    required this.id,
    required this.title,
    this.description,
    required this.departmentId,
    required this.duration,
    required this.isActive,
    required this.remainingAppointments,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['service_id'],
      title: json['title'],
      description: json['description'],
      departmentId: json['department_id'],
      duration: json['duration'] ?? 60, // Default to 1 hour
      isActive: json['status'] == 'Active',
      remainingAppointments: json['remaining_appointments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': id,
      'title': title,
      'description': description,
      'department_id': departmentId,
      'duration': duration,
      'status': isActive ? 'Active' : 'Inactive',
      'remaining_appointments': remainingAppointments,
    };
  }
}
