import { useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
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
} from "@/components/ui/dialog";
import { 
  Calendar as CalendarIcon, 
  Clock, 
  User, 
  FileText, 
  Phone,
  Mail,
  CheckCircle,
  XCircle,
  AlertCircle
} from "lucide-react";
import { format } from "date-fns";

interface Booking {
  id: number;
  citizenName: string;
  citizenEmail: string;
  citizenPhone: string;
  service: string;
  date: Date;
  time: string;
  status: "Pending" | "Confirmed" | "Cancelled" | "Completed";
  documents: string[];
  assignedOfficer?: string;
}

const Bookings = () => {
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(new Date());
  const [selectedService, setSelectedService] = useState<string>("all");
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  const [bookings] = useState<Booking[]>([
    {
      id: 1,
      citizenName: "Rajesh Perera",
      citizenEmail: "rajesh@email.com",
      citizenPhone: "+94771234567",
      service: "Birth Certificate",
      date: new Date(),
      time: "10:00 AM",
      status: "Pending",
      documents: ["Hospital Birth Record", "Parents' ID Copies"],
    },
    {
      id: 2,
      citizenName: "Saman Silva",
      citizenEmail: "saman@email.com",
      citizenPhone: "+94777654321",
      service: "Marriage Certificate",
      date: new Date(),
      time: "11:30 AM",
      status: "Confirmed",
      documents: ["Birth Certificates", "ID Copies", "Marriage Photos"],
      assignedOfficer: "Officer John Doe"
    },
    {
      id: 3,
      citizenName: "Nimal Fernando",
      citizenEmail: "nimal@email.com",
      citizenPhone: "+94765432109",
      service: "Death Certificate",
      date: new Date(Date.now() + 86400000), // Tomorrow
      time: "2:00 PM",
      status: "Pending",
      documents: ["Medical Report", "ID Copy", "Witness Statement"],
    },
    {
      id: 4,
      citizenName: "Kamala Wickrama",
      citizenEmail: "kamala@email.com",
      citizenPhone: "+94712345678",
      service: "Name Change Certificate",
      date: new Date(Date.now() + 86400000), // Tomorrow
      time: "3:30 PM",
      status: "Confirmed",
      documents: ["Current ID", "Gazette Notification", "Affidavit"],
      assignedOfficer: "Officer Jane Smith"
    }
  ]);

  const services = ["all", "Birth Certificate", "Marriage Certificate", "Death Certificate", "Name Change Certificate"];

  const filteredBookings = bookings.filter(booking => {
    const matchesService = selectedService === "all" || booking.service === selectedService;
    const matchesDate = !selectedDate || 
      booking.date.toDateString() === selectedDate.toDateString();
    return matchesService && matchesDate;
  });

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "Confirmed":
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case "Pending":
        return <AlertCircle className="w-4 h-4 text-orange-600" />;
      case "Cancelled":
        return <XCircle className="w-4 h-4 text-red-600" />;
      case "Completed":
        return <CheckCircle className="w-4 h-4 text-blue-600" />;
      default:
        return <AlertCircle className="w-4 h-4 text-gray-600" />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "Confirmed":
        return "bg-green-100 text-green-800";
      case "Pending":
        return "bg-orange-100 text-orange-800";
      case "Cancelled":
        return "bg-red-100 text-red-800";
      case "Completed":
        return "bg-blue-100 text-blue-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const handleBookingClick = (booking: Booking) => {
    setSelectedBooking(booking);
    setIsDialogOpen(true);
  };

  const handleStatusChange = (bookingId: number, newStatus: string) => {
    // In a real app, this would update the database
    console.log(`Updating booking ${bookingId} to status: ${newStatus}`);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Bookings Management</h1>
          <p className="text-gray-600 mt-1">View and manage citizen appointments</p>
        </div>
      </div>

      {/* Filters and Calendar */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Calendar */}
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="text-lg">Select Date</CardTitle>
          </CardHeader>
          <CardContent>
            <Calendar
              mode="single"
              selected={selectedDate}
              onSelect={setSelectedDate}
              className="rounded-md border"
            />
          </CardContent>
        </Card>

        {/* Bookings List */}
        <div className="lg:col-span-2 space-y-4">
          {/* Service Filter */}
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center space-x-4">
                <label className="text-sm font-medium">Filter by Service:</label>
                <Select value={selectedService} onValueChange={setSelectedService}>
                  <SelectTrigger className="w-48">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {services.map(service => (
                      <SelectItem key={service} value={service}>
                        {service === "all" ? "All Services" : service}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </CardContent>
          </Card>

          {/* Bookings for Selected Date */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <CalendarIcon className="w-5 h-5 mr-2" />
                Appointments for {selectedDate ? format(selectedDate, "MMMM d, yyyy") : "Selected Date"}
              </CardTitle>
              <CardDescription>
                {filteredBookings.length} appointment(s) found
              </CardDescription>
            </CardHeader>
            <CardContent>
              {filteredBookings.length === 0 ? (
                <div className="text-center py-8 text-gray-500">
                  <CalendarIcon className="w-12 h-12 mx-auto mb-4 text-gray-300" />
                  <p>No appointments found for the selected criteria</p>
                </div>
              ) : (
                <div className="space-y-4">
                  {filteredBookings.map((booking) => (
                    <div
                      key={booking.id}
                      className="border rounded-lg p-4 hover:shadow-sm transition-shadow cursor-pointer"
                      onClick={() => handleBookingClick(booking)}
                    >
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-4">
                          <div className="flex-1">
                            <div className="flex items-center space-x-2">
                              <h3 className="font-semibold text-gray-900">{booking.citizenName}</h3>
                              <Badge className={`text-xs ${getStatusColor(booking.status)}`}>
                                {booking.status}
                              </Badge>
                            </div>
                            <p className="text-sm text-gray-600">{booking.service}</p>
                            <div className="flex items-center space-x-4 mt-2 text-sm text-gray-500">
                              <div className="flex items-center">
                                <Clock className="w-4 h-4 mr-1" />
                                {booking.time}
                              </div>
                              <div className="flex items-center">
                                <Phone className="w-4 h-4 mr-1" />
                                {booking.citizenPhone}
                              </div>
                            </div>
                            {booking.assignedOfficer && (
                              <div className="flex items-center mt-1 text-sm text-blue-600">
                                <User className="w-4 h-4 mr-1" />
                                Assigned to: {booking.assignedOfficer}
                              </div>
                            )}
                          </div>
                        </div>
                        <div className="flex items-center space-x-2">
                          {getStatusIcon(booking.status)}
                          <Select
                            value={booking.status}
                            onValueChange={(value) => handleStatusChange(booking.id, value)}
                          >
                            <SelectTrigger className="w-32">
                              <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="Pending">Pending</SelectItem>
                              <SelectItem value="Confirmed">Confirmed</SelectItem>
                              <SelectItem value="Completed">Completed</SelectItem>
                              <SelectItem value="Cancelled">Cancelled</SelectItem>
                            </SelectContent>
                          </Select>
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

      {/* Booking Details Dialog */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="sm:max-w-lg">
          <DialogHeader>
            <DialogTitle>Appointment Details</DialogTitle>
            <DialogDescription>
              View and manage appointment information
            </DialogDescription>
          </DialogHeader>
          
          {selectedBooking && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium text-gray-600">Citizen Name</label>
                  <p className="font-semibold">{selectedBooking.citizenName}</p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-600">Status</label>
                  <Badge className={`ml-2 ${getStatusColor(selectedBooking.status)}`}>
                    {selectedBooking.status}
                  </Badge>
                </div>
              </div>

              <div>
                <label className="text-sm font-medium text-gray-600">Service</label>
                <p className="font-semibold">{selectedBooking.service}</p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium text-gray-600">Date</label>
                  <p>{format(selectedBooking.date, "MMMM d, yyyy")}</p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-600">Time</label>
                  <p>{selectedBooking.time}</p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium text-gray-600">Email</label>
                  <p className="flex items-center">
                    <Mail className="w-4 h-4 mr-1" />
                    {selectedBooking.citizenEmail}
                  </p>
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-600">Phone</label>
                  <p className="flex items-center">
                    <Phone className="w-4 h-4 mr-1" />
                    {selectedBooking.citizenPhone}
                  </p>
                </div>
              </div>

              {selectedBooking.assignedOfficer && (
                <div>
                  <label className="text-sm font-medium text-gray-600">Assigned Officer</label>
                  <p className="flex items-center">
                    <User className="w-4 h-4 mr-1" />
                    {selectedBooking.assignedOfficer}
                  </p>
                </div>
              )}

              <div>
                <label className="text-sm font-medium text-gray-600">Required Documents</label>
                <div className="mt-1 space-y-1">
                  {selectedBooking.documents.map((doc, index) => (
                    <div key={index} className="flex items-center text-sm">
                      <FileText className="w-4 h-4 mr-2 text-gray-400" />
                      {doc}
                    </div>
                  ))}
                </div>
              </div>

              <div className="flex space-x-2 pt-4">
                <Button variant="outline" className="flex-1">
                  Assign Officer
                </Button>
                <Button variant="outline" className="flex-1">
                  Send Message
                </Button>
                <Button className="flex-1 bg-green-600 hover:bg-green-700">
                  Mark Complete
                </Button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-blue-50 rounded-lg">
                <CalendarIcon className="w-6 h-6 text-blue-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Total Bookings</p>
                <p className="text-2xl font-bold text-gray-900">{bookings.length}</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-orange-50 rounded-lg">
                <AlertCircle className="w-6 h-6 text-orange-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Pending</p>
                <p className="text-2xl font-bold text-gray-900">
                  {bookings.filter(b => b.status === "Pending").length}
                </p>
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
                <p className="text-sm font-medium text-gray-600">Confirmed</p>
                <p className="text-2xl font-bold text-gray-900">
                  {bookings.filter(b => b.status === "Confirmed").length}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6">
            <div className="flex items-center">
              <div className="p-2 bg-purple-50 rounded-lg">
                <Clock className="w-6 h-6 text-purple-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">Today's Appointments</p>
                <p className="text-2xl font-bold text-gray-900">
                  {bookings.filter(b => b.date.toDateString() === new Date().toDateString()).length}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Bookings;
