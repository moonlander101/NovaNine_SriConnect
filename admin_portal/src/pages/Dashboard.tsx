import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { CalendarDays, Users, ClipboardList, TrendingUp, Building2, Clock } from "lucide-react";

interface DashboardStats {
  totalBookings: number;
  pendingBookings: number;
  totalServices: number;
  totalUsers: number;
  completedBookings: number;
  todayBookings: number;
}

const Dashboard = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState<any>(null);
  const [stats, setStats] = useState<DashboardStats>({
    totalBookings: 145,
    pendingBookings: 23,
    totalServices: 8,
    totalUsers: 45,
    completedBookings: 122,
    todayBookings: 12
  });

  useEffect(() => {
    const userData = localStorage.getItem("admin_user");
    if (!userData) {
      navigate("/");
      return;
    }
    setUser(JSON.parse(userData));
  }, [navigate]);

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
      value: `${Math.round((stats.completedBookings / stats.totalBookings) * 100)}%`,
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
            {user.department}
          </Badge>
        </div>
      </div>

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
              {[
                { name: "Rajesh Perera", service: "Birth Certificate", time: "10:00 AM", status: "Pending" },
                { name: "Saman Silva", service: "Marriage Certificate", time: "11:30 AM", status: "Confirmed" },
                { name: "Nimal Fernando", service: "Death Certificate", time: "2:00 PM", status: "Pending" },
                { name: "Kamala Wickrama", service: "Name Change", time: "3:30 PM", status: "Confirmed" }
              ].map((booking, index) => (
                <div key={index} className="flex items-center justify-between py-2 border-b last:border-b-0">
                  <div>
                    <p className="font-medium text-sm">{booking.name}</p>
                    <p className="text-xs text-gray-500">{booking.service}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium">{booking.time}</p>
                    <Badge 
                      variant={booking.status === "Confirmed" ? "default" : "secondary"}
                      className="text-xs"
                    >
                      {booking.status}
                    </Badge>
                  </div>
                </div>
              ))}
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
