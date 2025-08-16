import { useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Switch } from "@/components/ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { 
  Building2, 
  Mail, 
  Phone, 
  Clock, 
  Bell, 
  Shield,
  Save
} from "lucide-react";

const Settings = () => {
  const [departmentSettings, setDepartmentSettings] = useState({
    name: "Department of Registration of Persons",
    description: "Government department responsible for civil registration services including birth, death, marriage certificates and related documentation.",
    email: "info@drp.gov.lk",
    phone: "+94112345678",
    address: "123 Government Buildings, Colombo 01, Sri Lanka",
    workingHours: "Monday to Friday, 8:30 AM - 4:30 PM"
  });

  const [notificationSettings, setNotificationSettings] = useState({
    emailNotifications: true,
    smsNotifications: true,
    appointmentReminders: true,
    statusUpdates: true,
    weeklyReports: false
  });

  const [systemSettings, setSystemSettings] = useState({
    maxAppointmentsPerDay: 50,
    appointmentDuration: 30,
    advanceBookingDays: 30,
    autoConfirmAppointments: false,
    allowCancellations: true,
    cancellationDeadlineHours: 24
  });

  const handleSaveDepartmentSettings = () => {
    // In a real app, this would save to the database
    console.log("Saving department settings:", departmentSettings);
  };

  const handleSaveNotificationSettings = () => {
    // In a real app, this would save to the database
    console.log("Saving notification settings:", notificationSettings);
  };

  const handleSaveSystemSettings = () => {
    // In a real app, this would save to the database
    console.log("Saving system settings:", systemSettings);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Settings</h1>
        <p className="text-gray-600 mt-1">Manage department settings and configurations</p>
      </div>

      <Tabs defaultValue="department" className="space-y-6">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="department">Department Info</TabsTrigger>
          <TabsTrigger value="notifications">Notifications</TabsTrigger>
          <TabsTrigger value="system">System Settings</TabsTrigger>
        </TabsList>

        <TabsContent value="department" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Building2 className="w-5 h-5 mr-2" />
                Department Information
              </CardTitle>
              <CardDescription>
                Update department details that will be visible to citizens
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <Label htmlFor="deptName">Department Name</Label>
                <Input
                  id="deptName"
                  value={departmentSettings.name}
                  onChange={(e) => setDepartmentSettings({
                    ...departmentSettings, 
                    name: e.target.value
                  })}
                />
              </div>

              <div>
                <Label htmlFor="description">Description</Label>
                <Textarea
                  id="description"
                  value={departmentSettings.description}
                  onChange={(e) => setDepartmentSettings({
                    ...departmentSettings, 
                    description: e.target.value
                  })}
                  rows={3}
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="email">Email Address</Label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                    <Input
                      id="email"
                      type="email"
                      value={departmentSettings.email}
                      onChange={(e) => setDepartmentSettings({
                        ...departmentSettings, 
                        email: e.target.value
                      })}
                      className="pl-10"
                    />
                  </div>
                </div>

                <div>
                  <Label htmlFor="phone">Phone Number</Label>
                  <div className="relative">
                    <Phone className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                    <Input
                      id="phone"
                      value={departmentSettings.phone}
                      onChange={(e) => setDepartmentSettings({
                        ...departmentSettings, 
                        phone: e.target.value
                      })}
                      className="pl-10"
                    />
                  </div>
                </div>
              </div>

              <div>
                <Label htmlFor="address">Address</Label>
                <Textarea
                  id="address"
                  value={departmentSettings.address}
                  onChange={(e) => setDepartmentSettings({
                    ...departmentSettings, 
                    address: e.target.value
                  })}
                  rows={2}
                />
              </div>

              <div>
                <Label htmlFor="hours">Working Hours</Label>
                <div className="relative">
                  <Clock className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                  <Input
                    id="hours"
                    value={departmentSettings.workingHours}
                    onChange={(e) => setDepartmentSettings({
                      ...departmentSettings, 
                      workingHours: e.target.value
                    })}
                    className="pl-10"
                  />
                </div>
              </div>

              <Button onClick={handleSaveDepartmentSettings} className="w-full sm:w-auto">
                <Save className="w-4 h-4 mr-2" />
                Save Department Settings
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="notifications" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Bell className="w-5 h-5 mr-2" />
                Notification Preferences
              </CardTitle>
              <CardDescription>
                Configure how and when notifications are sent
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="emailNotifs">Email Notifications</Label>
                    <p className="text-sm text-gray-500">Receive notifications via email</p>
                  </div>
                  <Switch
                    id="emailNotifs"
                    checked={notificationSettings.emailNotifications}
                    onCheckedChange={(checked) => setNotificationSettings({
                      ...notificationSettings, 
                      emailNotifications: checked
                    })}
                  />
                </div>

                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="smsNotifs">SMS Notifications</Label>
                    <p className="text-sm text-gray-500">Send SMS to citizens for important updates</p>
                  </div>
                  <Switch
                    id="smsNotifs"
                    checked={notificationSettings.smsNotifications}
                    onCheckedChange={(checked) => setNotificationSettings({
                      ...notificationSettings, 
                      smsNotifications: checked
                    })}
                  />
                </div>

                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="reminders">Appointment Reminders</Label>
                    <p className="text-sm text-gray-500">Send reminders 24 hours before appointments</p>
                  </div>
                  <Switch
                    id="reminders"
                    checked={notificationSettings.appointmentReminders}
                    onCheckedChange={(checked) => setNotificationSettings({
                      ...notificationSettings, 
                      appointmentReminders: checked
                    })}
                  />
                </div>

                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="statusUpdates">Status Updates</Label>
                    <p className="text-sm text-gray-500">Notify citizens when appointment status changes</p>
                  </div>
                  <Switch
                    id="statusUpdates"
                    checked={notificationSettings.statusUpdates}
                    onCheckedChange={(checked) => setNotificationSettings({
                      ...notificationSettings, 
                      statusUpdates: checked
                    })}
                  />
                </div>

                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="weeklyReports">Weekly Reports</Label>
                    <p className="text-sm text-gray-500">Receive weekly summary reports</p>
                  </div>
                  <Switch
                    id="weeklyReports"
                    checked={notificationSettings.weeklyReports}
                    onCheckedChange={(checked) => setNotificationSettings({
                      ...notificationSettings, 
                      weeklyReports: checked
                    })}
                  />
                </div>
              </div>

              <Button onClick={handleSaveNotificationSettings} className="w-full sm:w-auto">
                <Save className="w-4 h-4 mr-2" />
                Save Notification Settings
              </Button>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="system" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Shield className="w-5 h-5 mr-2" />
                System Configuration
              </CardTitle>
              <CardDescription>
                Configure system-wide settings for appointments and bookings
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <Label htmlFor="maxAppointments">Max Appointments Per Day</Label>
                  <Input
                    id="maxAppointments"
                    type="number"
                    value={systemSettings.maxAppointmentsPerDay}
                    onChange={(e) => setSystemSettings({
                      ...systemSettings, 
                      maxAppointmentsPerDay: parseInt(e.target.value) || 0
                    })}
                  />
                  <p className="text-sm text-gray-500 mt-1">Maximum number of appointments allowed per day</p>
                </div>

                <div>
                  <Label htmlFor="duration">Appointment Duration (minutes)</Label>
                  <Input
                    id="duration"
                    type="number"
                    value={systemSettings.appointmentDuration}
                    onChange={(e) => setSystemSettings({
                      ...systemSettings, 
                      appointmentDuration: parseInt(e.target.value) || 0
                    })}
                  />
                  <p className="text-sm text-gray-500 mt-1">Default duration for each appointment</p>
                </div>

                <div>
                  <Label htmlFor="advanceBooking">Advance Booking (days)</Label>
                  <Input
                    id="advanceBooking"
                    type="number"
                    value={systemSettings.advanceBookingDays}
                    onChange={(e) => setSystemSettings({
                      ...systemSettings, 
                      advanceBookingDays: parseInt(e.target.value) || 0
                    })}
                  />
                  <p className="text-sm text-gray-500 mt-1">How many days in advance citizens can book</p>
                </div>

                <div>
                  <Label htmlFor="cancellationDeadline">Cancellation Deadline (hours)</Label>
                  <Input
                    id="cancellationDeadline"
                    type="number"
                    value={systemSettings.cancellationDeadlineHours}
                    onChange={(e) => setSystemSettings({
                      ...systemSettings, 
                      cancellationDeadlineHours: parseInt(e.target.value) || 0
                    })}
                  />
                  <p className="text-sm text-gray-500 mt-1">Minimum hours before appointment to allow cancellation</p>
                </div>
              </div>

              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="autoConfirm">Auto-confirm Appointments</Label>
                    <p className="text-sm text-gray-500">Automatically confirm new appointments</p>
                  </div>
                  <Switch
                    id="autoConfirm"
                    checked={systemSettings.autoConfirmAppointments}
                    onCheckedChange={(checked) => setSystemSettings({
                      ...systemSettings, 
                      autoConfirmAppointments: checked
                    })}
                  />
                </div>

                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="allowCancellations">Allow Cancellations</Label>
                    <p className="text-sm text-gray-500">Allow citizens to cancel their appointments</p>
                  </div>
                  <Switch
                    id="allowCancellations"
                    checked={systemSettings.allowCancellations}
                    onCheckedChange={(checked) => setSystemSettings({
                      ...systemSettings, 
                      allowCancellations: checked
                    })}
                  />
                </div>
              </div>

              <Button onClick={handleSaveSystemSettings} className="w-full sm:w-auto">
                <Save className="w-4 h-4 mr-2" />
                Save System Settings
              </Button>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
};

export default Settings;
