import { useState, useEffect, useCallback } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Calendar } from "@/components/ui/calendar";
import { supabaseAdmin } from "@/lib/supabase";
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
  Settings,
  Loader2
} from "lucide-react";
import { format, addDays, startOfWeek, endOfWeek, eachDayOfInterval } from "date-fns";
import { timeSlotsApi, type TimeSlotWithService } from "@/services/timeSlotsApi";
import { servicesApi, type ServiceWithDepartment } from "@/services/servicesApi";
import type { TimeslotStatus } from "@/types/database";

interface TimeSlotDisplay {
  timeslot_id: number;
  service: ServiceWithDepartment | null;
  start_time: string;
  end_time: string;
  remaining_appointments: number;
  currentBookings: number;
  status: TimeslotStatus;
  created_at: string;
}

const TimeSlots = () => {
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(new Date());
  const [selectedService, setSelectedService] = useState<string>("all");
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [editingSlot, setEditingSlot] = useState<TimeSlotDisplay | null>(null);
  const [deletingSlot, setDeletingSlot] = useState<TimeSlotDisplay | null>(null);
  const [viewMode, setViewMode] = useState<"day" | "week">("day");
  const [loading, setLoading] = useState(true);
  const [services, setServices] = useState<ServiceWithDepartment[]>([]);
  const [timeSlots, setTimeSlots] = useState<TimeSlotDisplay[]>([]);
  const [error, setError] = useState<string | null>(null);

  // Load services and time slots on component mount
  useEffect(() => {
    loadInitialData();
  }, []);

  // Reload time slots when date or view mode changes
  useEffect(() => {
    if (selectedDate) {
      loadTimeSlotsForDate();
    }
  }, [selectedDate, viewMode]);

  const loadTimeSlotsForDate = useCallback(async () => {
    try {
      if (!selectedDate) return;
      
      console.log('Loading time slots for date:', selectedDate);
      
      let startDate: string;
      let endDate: string;
      
      if (viewMode === "day") {
        // For day view, get slots for the selected day
        startDate = format(selectedDate, 'yyyy-MM-dd') + 'T00:00:00';
        endDate = format(selectedDate, 'yyyy-MM-dd') + 'T23:59:59';
      } else {
        // For week view, get slots for the entire week
        const weekStart = startOfWeek(selectedDate, { weekStartsOn: 1 });
        const weekEnd = endOfWeek(selectedDate, { weekStartsOn: 1 });
        startDate = format(weekStart, 'yyyy-MM-dd') + 'T00:00:00';
        endDate = format(weekEnd, 'yyyy-MM-dd') + 'T23:59:59';
      }
      
      console.log('Date range:', startDate, 'to', endDate);
      
      // Load time slots for the date range
      const timeSlotsData = await timeSlotsApi.getByDateRange(startDate, endDate);
      console.log('Time slots loaded for date range:', timeSlotsData);
      
      // Get appointment counts for each slot
      const timeSlotsWithCounts = await Promise.all(
        timeSlotsData.map(async (slot) => {
          const currentBookings = await timeSlotsApi.getAppointmentCount(slot.timeslot_id);
          return {
            ...slot,
            currentBookings
          };
        })
      );
      
      // Transform the data to match our display interface
      const transformedSlots: TimeSlotDisplay[] = timeSlotsWithCounts.map(slot => ({
        timeslot_id: slot.timeslot_id,
        service: slot.service || null,
        start_time: slot.start_time,
        end_time: slot.end_time,
        remaining_appointments: slot.remaining_appointments,
        currentBookings: slot.currentBookings,
        status: slot.status,
        created_at: slot.created_at
      }));
      
      console.log('Transformed slots for date:', transformedSlots);
      setTimeSlots(transformedSlots);
    } catch (err) {
      console.error('Failed to load time slots for date:', err);
      setError(err instanceof Error ? err.message : 'Failed to load time slots for selected date');
    }
  }, [selectedDate, viewMode]);

  const loadInitialData = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Test the exact same query that works in CLI
      console.log('🧪 Testing exact CLI query...')
      const { data: testData, error: testError } = await supabaseAdmin
        .from('time_slot')
        .select(`
          *,
          service (
            service_id,
            title,
            description,
            department_id,
            created_at,
            updated_at
          )
        `)
        .order('start_time', { ascending: true })

      if (testError) {
        console.error('❌ CLI test query failed:', testError)
        console.error('❌ Error details:', {
          message: testError.message,
          details: testError.details,
          hint: testError.hint,
          code: testError.code
        })
      } else {
        console.log('✅ CLI test query successful!')
        console.log('📊 Test data count:', testData?.length || 0)
      }
      
      // Load services
      console.log('🔍 Loading services...')
      const servicesData = await servicesApi.getAll();
      console.log('✅ Services loaded in TimeSlots:', servicesData)
      setServices(servicesData);
      
      // Load time slots for the selected date
      if (selectedDate) {
        await loadTimeSlotsForDate();
      }
    } catch (err) {
      console.error('Failed to load initial data:', err);
      setError(err instanceof Error ? err.message : 'Failed to load data');
    } finally {
      setLoading(false);
    }
  }, [selectedDate, loadTimeSlotsForDate]);

  const [newSlot, setNewSlot] = useState({
    service_id: 0,
    start_time: "",
    end_time: "",
    remaining_appointments: 5,
    status: "Active" as TimeslotStatus
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
    const matchesService = selectedService === "all" || 
      (slot.service && slot.service.service_id.toString() === selectedService);
    const displayDates = getDisplayDates();
    const slotDate = new Date(slot.start_time);
    const matchesDate = displayDates.some(date => 
      slotDate.toDateString() === date.toDateString()
    );
    return matchesService && matchesDate;
  });

  const getStatusColor = (status: TimeslotStatus) => {
    switch (status) {
      case "Active":
        return "bg-green-100 text-green-800";
      case "Inactive":
        return "bg-gray-100 text-gray-800";
      case "Full":
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

  const handleAddSlot = async () => {
    try {
      if (!newSlot.service_id || !newSlot.start_time || !newSlot.end_time) {
        alert("Please fill in all required fields");
        return;
      }

      await timeSlotsApi.create(newSlot);
      await loadInitialData(); // Reload data
      setIsAddDialogOpen(false);
      setNewSlot({
        service_id: 0,
        start_time: "",
        end_time: "",
        remaining_appointments: 5,
        status: "Active" as TimeslotStatus
      });
    } catch (error) {
      console.error('Failed to create time slot:', error);
      alert('Failed to create time slot');
    }
  };

  const handleEditSlot = (slot: TimeSlotDisplay) => {
    setEditingSlot(slot);
  };

  const handleDeleteSlot = async (slot: TimeSlotDisplay) => {
    try {
      await timeSlotsApi.delete(slot.timeslot_id);
      await loadInitialData(); // Reload data
      setDeletingSlot(null);
    } catch (error) {
      console.error('Failed to delete time slot:', error);
      alert('Failed to delete time slot');
    }
  };

  const handleToggleSlotStatus = async (slotId: number) => {
    try {
      const slot = timeSlots.find(s => s.timeslot_id === slotId);
      if (!slot) return;

      const newStatus: TimeslotStatus = slot.status === "Active" ? "Inactive" : "Active";
      await timeSlotsApi.update(slotId, { status: newStatus });
      await loadInitialData(); // Reload data
    } catch (error) {
      console.error('Failed to update time slot status:', error);
      alert('Failed to update time slot status');
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <Loader2 className="w-8 h-8 animate-spin" />
        <span className="ml-2">Loading time slots...</span>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center h-64">
        <AlertCircle className="w-8 h-8 text-red-500" />
        <span className="ml-2 text-red-600">{error}</span>
        <Button onClick={loadInitialData} className="ml-4">
          Retry
        </Button>
      </div>
    );
  }

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
              <Button className="bg-blue-600 hover:bg-blue-700" disabled={loading}>
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
                    value={newSlot.service_id.toString()} 
                    onValueChange={(value) => setNewSlot({...newSlot, service_id: parseInt(value)})}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Select a service" />
                    </SelectTrigger>
                    <SelectContent>
                      {services.map(service => (
                        <SelectItem key={service.service_id} value={service.service_id.toString()}>
                          {service.title}
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
                      type="datetime-local"
                      value={newSlot.start_time}
                      onChange={(e) => setNewSlot({...newSlot, start_time: e.target.value})}
                    />
                  </div>
                  <div>
                    <Label htmlFor="endTime">End Time</Label>
                    <Input
                      id="endTime"
                      type="datetime-local"
                      value={newSlot.end_time}
                      onChange={(e) => setNewSlot({...newSlot, end_time: e.target.value})}
                    />
                  </div>
                </div>

                <div>
                  <Label htmlFor="capacity">Max Appointments</Label>
                  <Input
                    id="capacity"
                    type="number"
                    min="1"
                    max="20"
                    value={newSlot.remaining_appointments}
                    onChange={(e) => setNewSlot({...newSlot, remaining_appointments: parseInt(e.target.value) || 1})}
                  />
                </div>

                <Button 
                  onClick={handleAddSlot} 
                  className="w-full"
                  disabled={!newSlot.service_id || !newSlot.start_time || !newSlot.end_time}
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
                  {services.map(service => (
                    <SelectItem key={service.service_id} value={service.service_id.toString()}>
                      {service.title}
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
                      key={slot.timeslot_id}
                      className="border rounded-lg p-4 hover:shadow-sm transition-shadow"
                    >
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                          <div className="flex-1">
                            <div className="flex items-center space-x-2">
                              <h3 className="font-semibold text-gray-900">
                                {slot.service?.title || 'No Service'}
                              </h3>
                              <Badge className={`text-xs ${getStatusColor(slot.status)}`}>
                                {slot.status}
                              </Badge>
                            </div>
                            <div className="flex items-center space-x-4 mt-2 text-sm text-gray-500">
                              <div className="flex items-center">
                                <Clock className="w-4 h-4 mr-1" />
                                {format(new Date(slot.start_time), "HH:mm")} - {format(new Date(slot.end_time), "HH:mm")}
                              </div>
                              <div className="flex items-center">
                                <Users className="w-4 h-4 mr-1" />
                                <span className={getCapacityColor(slot.currentBookings, slot.remaining_appointments)}>
                                  {slot.currentBookings}/{slot.remaining_appointments}
                                </span>
                              </div>
                              <div className="flex items-center">
                                <CalendarIcon className="w-4 h-4 mr-1" />
                                {format(new Date(slot.start_time), "MMM d, yyyy")}
                              </div>
                            </div>
                          </div>
                        </div>
                        <div className="flex items-center space-x-2">
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleToggleSlotStatus(slot.timeslot_id)}
                          >
                            {slot.status === "Active" ? (
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
                  {timeSlots.filter(s => s.status === "Active").length}
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
                  {timeSlots.filter(s => s.status === "Full").length}
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
