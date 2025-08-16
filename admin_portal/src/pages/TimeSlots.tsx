import { useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Calendar } from "@/components/ui/calendar";
import { 
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { 
  Clock, 
  Plus, 
  Calendar as CalendarIcon, 
  Edit, 
  Trash2, 
  Users, 
  CheckCircle,
  AlertCircle,
  Settings
} from "lucide-react";
import { format, addDays, startOfWeek, endOfWeek, eachDayOfInterval } from "date-fns";

interface TimeSlot {
  id: number;
  service: string;
  date: Date;
  startTime: string;
  endTime: string;
  maxCapacity: number;
  currentBookings: number;
  status: "active" | "inactive" | "full";
  isRecurring: boolean;
  recurringDays?: string[];
  notes?: string;
}

interface Service {
  id: number;
  name: string;
  isActive: boolean;
}

const TimeSlots = () => {
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(new Date());
  const [selectedService, setSelectedService] = useState<string>("all");
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [editingSlot, setEditingSlot] = useState<TimeSlot | null>(null);
  const [deletingSlot, setDeletingSlot] = useState<TimeSlot | null>(null);
  const [viewMode, setViewMode] = useState<"day" | "week">("day");

  // Mock services data
  const [services] = useState<Service[]>([
    { id: 1, name: "Birth Certificate", isActive: true },
    { id: 2, name: "Marriage Certificate", isActive: true },
    { id: 3, name: "Death Certificate", isActive: true },
    { id: 4, name: "Name Change Certificate", isActive: true },
  ]);

  // Mock time slots data
  const [timeSlots, setTimeSlots] = useState<TimeSlot[]>([
    {
      id: 1,
      service: "Birth Certificate",
      date: new Date(),
      startTime: "09:00",
      endTime: "09:30",
      maxCapacity: 5,
      currentBookings: 3,
      status: "active",
      isRecurring: true,
      recurringDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      notes: "Standard morning slot"
    },
    {
      id: 2,
      service: "Birth Certificate",
      date: new Date(),
      startTime: "10:00",
      endTime: "10:30",
      maxCapacity: 5,
      currentBookings: 5,
      status: "full",
      isRecurring: true,
      recurringDays: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    },
    {
      id: 3,
      service: "Marriage Certificate",
      date: new Date(),
      startTime: "11:00",
      endTime: "11:30",
      maxCapacity: 3,
      currentBookings: 1,
      status: "active",
      isRecurring: true,
      recurringDays: ["Monday", "Wednesday", "Friday"]
    },
    {
      id: 4,
      service: "Death Certificate",
      date: addDays(new Date(), 1),
      startTime: "14:00",
      endTime: "14:30",
      maxCapacity: 4,
      currentBookings: 0,
      status: "active",
      isRecurring: false
    }
  ]);

  const [newSlot, setNewSlot] = useState({
    service: "",
    date: new Date(),
    startTime: "",
    endTime: "",
    maxCapacity: 5,
    isRecurring: false,
    recurringDays: [] as string[],
    notes: ""
  });

  const weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

  const getDisplayDates = () => {
    if (!selectedDate) return [];
    
    if (viewMode === "day") {
      return [selectedDate];
    } else {
      const start = startOfWeek(selectedDate, { weekStartsOn: 1 });
      const end = endOfWeek(selectedDate, { weekStartsOn: 1 });
      return eachDayOfInterval({ start, end });
    }
  };

  const filteredTimeSlots = timeSlots.filter(slot => {
    const matchesService = selectedService === "all" || slot.service === selectedService;
    const displayDates = getDisplayDates();
    const matchesDate = displayDates.some(date => 
      slot.date.toDateString() === date.toDateString()
    );
    return matchesService && matchesDate;
  });

  const getStatusColor = (status: string) => {
    switch (status) {
      case "active":
        return "bg-green-100 text-green-800";
      case "inactive":
        return "bg-gray-100 text-gray-800";
      case "full":
        return "bg-red-100 text-red-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const getCapacityColor = (current: number, max: number) => {
    const percentage = (current / max) * 100;
    if (percentage >= 100) return "text-red-600";
    if (percentage >= 80) return "text-orange-600";
    return "text-green-600";
  };

  const handleAddSlot = () => {
    const slot: TimeSlot = {
      id: timeSlots.length + 1,
      service: newSlot.service,
      date: newSlot.date,
      startTime: newSlot.startTime,
      endTime: newSlot.endTime,
      maxCapacity: newSlot.maxCapacity,
      currentBookings: 0,
      status: "active",
      isRecurring: newSlot.isRecurring,
      recurringDays: newSlot.isRecurring ? newSlot.recurringDays : undefined,
      notes: newSlot.notes
    };

    setTimeSlots([...timeSlots, slot]);
    setIsAddDialogOpen(false);
    setNewSlot({
      service: "",
      date: new Date(),
      startTime: "",
      endTime: "",
      maxCapacity: 5,
      isRecurring: false,
      recurringDays: [],
      notes: ""
    });
  };

  const handleEditSlot = (slot: TimeSlot) => {
    setEditingSlot(slot);
  };

  const handleDeleteSlot = (slot: TimeSlot) => {
    setTimeSlots(timeSlots.filter(s => s.id !== slot.id));
    setDeletingSlot(null);
  };

  const handleToggleSlotStatus = (slotId: number) => {
    setTimeSlots(timeSlots.map(slot => 
      slot.id === slotId 
        ? { ...slot, status: slot.status === "active" ? "inactive" : "active" as any }
        : slot
    ));
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Time Slots Management</h1>
          <p className="text-gray-600 mt-1">Manage appointment time slots for all services</p>
        </div>
        
        <div className="flex space-x-2">
          <Select value={viewMode} onValueChange={(value: "day" | "week") => setViewMode(value)}>
            <SelectTrigger className="w-32">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="day">Day View</SelectItem>
              <SelectItem value="week">Week View</SelectItem>
            </SelectContent>
          </Select>
          
          <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
            <DialogTrigger asChild>
              <Button className="bg-blue-600 hover:bg-blue-700">
                <Plus className="w-4 h-4 mr-2" />
                Add Time Slot
              </Button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-md">
              <DialogHeader>
                <DialogTitle>Add New Time Slot</DialogTitle>
                <DialogDescription>
                  Create a new time slot for appointments.
                </DialogDescription>
              </DialogHeader>
              <div className="space-y-4">
                <div>
                  <Label htmlFor="service">Service</Label>
                  <Select 
                    value={newSlot.service} 
                    onValueChange={(value) => setNewSlot({...newSlot, service: value})}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Select a service" />
                    </SelectTrigger>
                    <SelectContent>
                      {services.filter(s => s.isActive).map(service => (
                        <SelectItem key={service.id} value={service.name}>
                          {service.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="startTime">Start Time</Label>
                    <Input
                      id="startTime"
                      type="time"
                      value={newSlot.startTime}
                      onChange={(e) => setNewSlot({...newSlot, startTime: e.target.value})}
                    />
                  </div>
                  <div>
                    <Label htmlFor="endTime">End Time</Label>
                    <Input
                      id="endTime"
                      type="time"
                      value={newSlot.endTime}
                      onChange={(e) => setNewSlot({...newSlot, endTime: e.target.value})}
                    />
                  </div>
                </div>

                <div>
                  <Label htmlFor="capacity">Max Capacity</Label>
                  <Input
                    id="capacity"
                    type="number"
                    min="1"
                    value={newSlot.maxCapacity}
                    onChange={(e) => setNewSlot({...newSlot, maxCapacity: parseInt(e.target.value) || 1})}
                  />
                </div>

                <div className="flex items-center space-x-2">
                  <input
                    type="checkbox"
                    id="recurring"
                    checked={newSlot.isRecurring}
                    onChange={(e) => setNewSlot({...newSlot, isRecurring: e.target.checked})}
                    className="rounded"
                  />
                  <Label htmlFor="recurring">Recurring weekly</Label>
                </div>

                {newSlot.isRecurring && (
                  <div>
                    <Label>Recurring Days</Label>
                    <div className="grid grid-cols-2 gap-2 mt-2">
                      {weekDays.map(day => (
                        <div key={day} className="flex items-center space-x-2">
                          <input
                            type="checkbox"
                            id={day}
                            checked={newSlot.recurringDays.includes(day)}
                            onChange={(e) => {
                              if (e.target.checked) {
                                setNewSlot({
                                  ...newSlot, 
                                  recurringDays: [...newSlot.recurringDays, day]
                                });
                              } else {
                                setNewSlot({
                                  ...newSlot, 
                                  recurringDays: newSlot.recurringDays.filter(d => d !== day)
                                });
                              }
                            }}
                            className="rounded"
                          />
                          <Label htmlFor={day} className="text-sm">{day}</Label>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div>
                  <Label htmlFor="notes">Notes (Optional)</Label>
                  <Textarea
                    id="notes"
                    value={newSlot.notes}
                    onChange={(e) => setNewSlot({...newSlot, notes: e.target.value})}
                    placeholder="Add any additional notes..."
                  />
                </div>

                <Button 
                  onClick={handleAddSlot} 
                  className="w-full"
                  disabled={!newSlot.service || !newSlot.startTime || !newSlot.endTime}
                >
                  Add Time Slot
                </Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      {/* Filters and Calendar */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Calendar */}
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="text-lg flex items-center">
              <CalendarIcon className="w-5 h-5 mr-2" />
              {viewMode === "day" ? "Select Date" : "Select Week"}
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Calendar
              mode="single"
              selected={selectedDate}
              onSelect={setSelectedDate}
              className="rounded-md border"
            />
            
            <div className="mt-4 space-y-2">
              <Label>Filter by Service:</Label>
              <Select value={selectedService} onValueChange={setSelectedService}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Services</SelectItem>
                  {services.filter(s => s.isActive).map(service => (
                    <SelectItem key={service.id} value={service.name}>
                      {service.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </CardContent>
        </Card>

        {/* Time Slots List */}
        <div className="lg:col-span-3 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Clock className="w-5 h-5 mr-2" />
                Time Slots for {selectedDate ? format(selectedDate, "MMMM d, yyyy") : "Selected Date"}
              </CardTitle>
              <CardDescription>
                {filteredTimeSlots.length} time slot(s) found
              </CardDescription>
            </CardHeader>
            <CardContent>
              {filteredTimeSlots.length === 0 ? (
                <div className="text-center py-8 text-gray-500">
                  <Clock className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                  <p>No time slots found for the selected criteria</p>
                  <Button 
                    variant="outline" 
                    className="mt-4"
                    onClick={() => setIsAddDialogOpen(true)}
                  >
                    <Plus className="w-4 h-4 mr-2" />
                    Add First Time Slot
                  </Button>
                </div>
              ) : (
                <div className="space-y-4">
                  {filteredTimeSlots.map((slot) => (
                    <div
                      key={slot.id}
                      className="border rounded-lg p-4 hover:shadow-sm transition-shadow"
                    >
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                          <div className="flex-1">
                            <div className="flex items-center space-x-2">
                              <h3 className="font-semibold text-gray-900">{slot.service}</h3>
                              <Badge className={`text-xs ${getStatusColor(slot.status)}`}>
                                {slot.status}
                              </Badge>
                              {slot.isRecurring && (
                                <Badge variant="outline" className="text-xs">
                                  Recurring
                                </Badge>
                              )}
                            </div>
                            <div className="flex items-center space-x-4 mt-2 text-sm text-gray-500">
                              <div className="flex items-center">
                                <Clock className="w-4 h-4 mr-1" />
                                {slot.startTime} - {slot.endTime}
                              </div>
                              <div className="flex items-center">
                                <Users className="w-4 h-4 mr-1" />
                                <span className={getCapacityColor(slot.currentBookings, slot.maxCapacity)}>
                                  {slot.currentBookings}/{slot.maxCapacity}
                                </span>
                              </div>
                              <div className="flex items-center">
                                <CalendarIcon className="w-4 h-4 mr-1" />
                                {format(slot.date, "MMM d, yyyy")}
                              </div>
                            </div>
                            {slot.isRecurring && slot.recurringDays && (
                              <div className="mt-2 text-sm text-gray-500">
                                <span className="font-medium">Repeats:</span> {slot.recurringDays.join(", ")}
                              </div>
                            )}
                            {slot.notes && (
                              <div className="mt-2 text-sm text-gray-600">
                                <span className="font-medium">Notes:</span> {slot.notes}
                              </div>
                            )}
                          </div>
                        </div>
                        <div className="flex items-center space-x-2">
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleToggleSlotStatus(slot.id)}
                          >
                            {slot.status === "active" ? (
                              <>
                                <AlertCircle className="w-4 h-4 mr-1" />
                                Deactivate
                              </>
                            ) : (
                              <>
                                <CheckCircle className="w-4 h-4 mr-1" />
                                Activate
                              </>
                            )}
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleEditSlot(slot)}
                          >
                            <Edit className="w-4 h-4" />
                          </Button>
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => setDeletingSlot(slot)}
                          >
                            <Trash2 className="w-4 h-4" />
                          </Button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Summary Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-blue-50 rounded-lg">
                <Clock className="w-6 h-6 text-blue-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Time Slots</p>
                <p className="text-2xl font-bold text-gray-900">{timeSlots.length}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-green-50 rounded-lg">
                <CheckCircle className="w-6 h-6 text-green-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Active Slots</p>
                <p className="text-2xl font-bold text-gray-900">
                  {timeSlots.filter(s => s.status === "active").length}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-red-50 rounded-lg">
                <Users className="w-6 h-6 text-red-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Full Slots</p>
                <p className="text-2xl font-bold text-gray-900">
                  {timeSlots.filter(s => s.status === "full").length}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-purple-50 rounded-lg">
                <Settings className="w-6 h-6 text-purple-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Bookings</p>
                <p className="text-2xl font-bold text-gray-900">
                  {timeSlots.reduce((acc, slot) => acc + slot.currentBookings, 0)}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Delete Confirmation Dialog */}
      <AlertDialog open={!!deletingSlot} onOpenChange={() => setDeletingSlot(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete Time Slot</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to delete this time slot? This action cannot be undone.
              {deletingSlot?.currentBookings && deletingSlot.currentBookings > 0 && (
                <span className="block mt-2 text-red-600 font-medium">
                  Warning: This slot has {deletingSlot.currentBookings} existing booking(s).
                </span>
              )}
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction 
              onClick={() => deletingSlot && handleDeleteSlot(deletingSlot)}
              className="bg-red-600 hover:bg-red-700"
            >
              Delete
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
};

export default TimeSlots;
