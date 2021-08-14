/// A class to represent an event
class Event {
  String category;
  String description;
  DateTime startTime;
  DateTime endTime;
  String id;
  bool completed;
  bool passed;
  int difficulty;

  Event({this.category, this.description, this.startTime, this.endTime, this.id, this.completed, this.passed, this.difficulty});

  /// Returns the String representation of an event
  String toString() {
    return this.category + "\n" + this.description + "\n" + this.startTime.toString() + "\n" + this.endTime.toString();
  }

  /// Returns a map that represents the Event
  Map<String, Object> toMap() {
    return {
      "category": category,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
      "completed": completed,
      "passed": passed,
      "difficulty": difficulty,
    };
  }
}