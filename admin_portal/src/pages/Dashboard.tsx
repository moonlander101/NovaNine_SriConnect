import { useEffect, useState, useCallback } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { CalendarDays, Users, ClipboardList, TrendingUp, Building2, Clock } from "lucide-react";
import { appointmentsApi } from '@/services/appointmentsApi';
import { servicesApi } from '@/services/servicesApi';
import { usersApi } from '@/services/usersApi';
import { AppointmentWithDetails } from '@/types/database';
import { format, isToday } from 'date-fns';

interface DashboardStats {
  totalBookings: number;
  pendingBookings: number;
  confirmedBookings: number;
  completedBookings: number;
  cancelledBookings: number;
  totalServices: number;
  totalUsers: number;
  todayBookings: number;
  completionRate: number;
}

interface User {
  user_id: number;
  full_name: string;
  email: string;
  role: string;
  department?: string;
}

const Dashboard = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState<User | null>(null);
  const [stats, setStats] = useState<DashboardStats>({
    totalBookings: 0,
    pendingBookings: 0,
    confirmedBookings: 0,
    completedBookings: 0,
    cancelledBookings: 0,
    totalServices: 0,
    totalUsers: 0,
    todayBookings: 0,
    completionRate: 0
  });
  const [recentAppointments, setRecentAppointments] = useState<AppointmentWithDetails[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadDashboardData = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      // Load all data in parallel
      const [appointmentsData, servicesData, usersData] = await Promise.all([
        appointmentsApi.getAll(),
        servicesApi.getAll(),
        usersApi.getAll()
      ]);

      // Calculate appointment statistics
      const totalBookings = appointmentsData.length;
      const pendingBookings = appointmentsData.filter(apt => apt.status === 'Pending').length;
      const confirmedBookings = appointmentsData.filter(apt => apt.status === 'Confirmed').length;
      const completedBookings = appointmentsData.filter(apt => apt.status === 'Completed').length;
      const cancelledBookings = appointmentsData.filter(apt => apt.status === 'Cancelled').length;
      
      // Calculate today's bookings (based on created date since timeslot doesn't have date)
      const todayBookings = appointmentsData.filter(apt => {
        return isToday(new Date(apt.created_at));
      }).length;

      // Calculate completion rate
      const completionRate = totalBookings > 0 ? Math.round((completedBookings / totalBookings) * 100) : 0;

      setStats({
        totalBookings,
        pendingBookings,
        confirmedBookings,
        completedBookings,
        cancelledBookings,
        totalServices: servicesData.length,
        totalUsers: usersData.length,
        todayBookings,
        completionRate
      });

      // Set recent appointments (last 5)
      const sortedAppointments = appointmentsData
        .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
        .slice(0, 5);
      
      setRecentAppointments(sortedAppointments);

    } catch (err) {
      console.error('Error loading dashboard data:', err);
      setError('Failed to load dashboard data');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    const userData = localStorage.getItem("admin_user");
    if (!userData) {
      navigate("/");
      return;
    }
    setUser(JSON.parse(userData));
    loadDashboardData();
  }, [navigate, loadDashboardData]);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg">Loading dashboard data...</div>
      </div>
    );
  }

  if (!user) return null;

  const statCards = [
    {
      title: "Total Bookings",
      value: stats.totalBookings,
      description: "All time bookings",
      icon: ClipboardList,
      color: "text-blue-600",
      bgColor: "bg-blue-50"
    },
    {
      title: "Pending Bookings",
      value: stats.pendingBookings,
      description: "Awaiting confirmation",
      icon: Clock,
      color: "text-orange-600",
      bgColor: "bg-orange-50"
    },
    {
      title: "Today's Bookings",
      value: stats.todayBookings,
      description: "Scheduled for today",
      icon: CalendarDays,
      color: "text-green-600",
      bgColor: "bg-green-50"
    },
    {
      title: "Active Services",
      value: stats.totalServices,
      description: "Available services",
      icon: Building2,
      color: "text-purple-600",
      bgColor: "bg-purple-50"
    },
    {
      title: "Department Users",
      value: stats.totalUsers,
      description: "Staff members",
      icon: Users,
      color: "text-indigo-600",
      bgColor: "bg-indigo-50"
    },
    {
      title: "Completion Rate",
      value: `${stats.completionRate}%`,
      description: "Successful appointments",
      icon: TrendingUp,
      color: "text-emerald-600",
      bgColor: "bg-emerald-50"
    }
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="border-b pb-4">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
            <p className="text-gray-600 mt-1">Welcome back, {user.full_name}</p>
          </div>
          <Badge variant="secondary" className="text-sm">
            {user.role}
          </Badge>
        </div>
      </div>

      {error && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {statCards.map((stat, index) => {
          const IconComponent = stat.icon;
          return (
            <Card key={index} className="hover:shadow-md transition-shadow">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-gray-600">
                  {stat.title}
                </CardTitle>
                <div className={`p-2 rounded-lg ${stat.bgColor}`}>
                  <IconComponent className={`w-4 h-4 ${stat.color}`} />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-gray-900">{stat.value}</div>
                <p className="text-xs text-gray-500 mt-1">{stat.description}</p>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Recent Bookings</CardTitle>
            <CardDescription>Latest appointment requests</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {recentAppointments.length > 0 ? (
                recentAppointments.map((appointment) => (
                  <div key={appointment.appointment_id} className="flex items-center justify-between py-2 border-b last:border-b-0">
                    <div>
                      <p className="font-medium text-sm">{appointment.citizen?.full_name || 'Unknown'}</p>
                      <p className="text-xs text-gray-500">{appointment.service?.title || 'No service'}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-sm font-medium">
                        {appointment.timeslot 
                          ? `${appointment.timeslot.start_time} - ${appointment.timeslot.end_time}`
                          : format(new Date(appointment.created_at), 'MMM dd, yyyy')
                        }
                      </p>
                      <Badge 
                        variant={appointment.status === "Confirmed" ? "default" : "secondary"}
                        className="text-xs"
                      >
                        {appointment.status}
                      </Badge>
                    </div>
                  </div>
                ))
              ) : (
                <div className="text-center py-4 text-gray-500">
                  No recent appointments
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Quick Actions</CardTitle>
            <CardDescription>Common administrative tasks</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 gap-3">
              {[
                { label: "Add New Service", color: "bg-blue-600 hover:bg-blue-700", href: "/services" },
                { label: "Manage Time Slots", color: "bg-green-600 hover:bg-green-700", href: "/time-slots" },
                { label: "Add Staff Member", color: "bg-purple-600 hover:bg-purple-700", href: "/users" },
                { label: "View Reports", color: "bg-orange-600 hover:bg-orange-700", href: "/bookings" }
              ].map((action, index) => (
                <button
                  key={index}
                  onClick={() => navigate(action.href)}
                  className={`p-3 rounded-lg text-white text-sm font-medium transition-colors ${action.color}`}
                >
                  {action.label}
                </button>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Dashboard;
